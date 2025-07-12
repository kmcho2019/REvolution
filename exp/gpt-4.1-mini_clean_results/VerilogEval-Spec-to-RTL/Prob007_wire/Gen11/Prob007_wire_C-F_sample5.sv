module TopModule(input wire in, output wire out);
  // Local wire-pass-through module definition
  module WirePassThroughLocal(input wire in_local, output wire out_local);
    assign out_local = in_local;
  endmodule

  // Instantiate the local wire-pass-through module
  WirePassThroughLocal wire_inst(.in_local(in), .out_local(out));
endmodule