module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// Set out_both[99] to 0
assign out_both[99] = 1'b0;

// Generate out_both
genvar i;
generate
    for (i = 0; i < 99; i++) begin
        assign out_both[i] = in[i] & in[i+1];
    end
endgenerate

// Set out_any[0] to 0
assign out_any[0] = 1'b0;

// Generate out_any
generate
    for (i = 1; i < 100; i++) begin
        assign out_any[i] = in[i] | in[i-1];
    end
endgenerate

// Generate out_different
generate
    for (i = 0; i < 100; i++) begin
        assign out_different[i] = in[i] ^ in[(i+1)%100];
    end
endgenerate

endmodule