module TopModule(input wire in, output wire out);
  wire drive;

  // Enable is always 1, so tri-state buffer passes input directly
  assign drive = in;
  assign out = drive;
endmodule