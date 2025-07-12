interface WireIf();
  logic signal;
  modport input_mp (input signal);
  modport output_mp (output signal);
endinterface

module TopModule(input wire in, output wire out);
  WireIf wire_if();

  assign wire_if.signal = in;
  assign out = wire_if.signal;
endmodule