module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    
// Directly compute output based on XOR results without intermediate signals
assign out = (a ^ b) ^ (c ^ d);

endmodule