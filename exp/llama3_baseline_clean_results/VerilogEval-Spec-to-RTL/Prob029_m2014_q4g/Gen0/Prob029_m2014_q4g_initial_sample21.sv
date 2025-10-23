module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

assign out = ~(in1 ^ in2) ^ in3;

// Alternatively, you could break it down for clarity:
// wire xnor_out;
// assign xnor_out = ~(in1 ^ in2);
// assign out = xnor_out ^ in3;

endmodule