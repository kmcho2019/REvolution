module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

wire xnor_out;

assign xnor_out = ~(in1 ^ in2); // Implementing XNOR using XOR and inverter
assign out = xnor_out ^ in3;    // Connecting XNOR output to one input of XOR

endmodule