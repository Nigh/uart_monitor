

void setup(void)
{
	Serial.begin(115200);
	Serial1.begin(115200);
	Serial2.begin(115200);
	Serial.println("Monitor is online...");
}


void loop(void)
{
	while(Serial1.available()){
		uart1_parser(Serial1.read());
	}
	while(Serial2.available()){
		uart2_parser(Serial2.read());
	}
}


void uart1_parser(unsigned char byte)
{
	static struct buffer
	{
		unsigned char length;
		unsigned char buffer[64];
	}buf1={0,{0}};
	buf1.buffer[buf1.length++]=byte;
	if(buf1.length>16){
		Serial.print("U1[");
		Serial.write(buf1.length);
		Serial.print("]:");
		Serial.write(buf1.buffer,buf1.length);
		buf1.length = 0;
	}
}

void uart2_parser(unsigned char byte)
{
	static struct buffer
	{
		unsigned char length;
		unsigned char buffer[64];
	}buf2={0,{0}};
	buf2.buffer[buf2.length++]=byte;
	if(buf2.length>16){
		Serial.print("U2[");
		Serial.write(buf2.length);
		Serial.print("]:");
		Serial.write(buf2.buffer,buf2.length);
		buf2.length = 0;
	}
}
