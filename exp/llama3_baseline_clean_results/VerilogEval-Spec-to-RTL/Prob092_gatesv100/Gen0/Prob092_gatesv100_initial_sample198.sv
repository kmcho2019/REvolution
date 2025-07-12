module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// Initialize out_both, out_any, and out_different vectors
assign out_both[99] = 1'b0; // Since in[99] has no neighbour to the left
assign out_any[0] = 1'b0; // Since in[0] has no neighbour to the right

// Calculate out_both
genvar i;
generate
    for (i = 99; i > 0; i = i - 1) begin
        assign out_both[i-1] = in[i] & in[i-1];
    end
endgenerate

// Calculate out_any
generate
    for (i = 1; i < 100; i = i + 1) begin
        assign out_any[i] = in[i] | in[i-1];
    end
endgenerate

// Calculate out_different
generate
    for (i = 0; i < 100; i = i + 1) begin
        assign out_different[i] = in[i] != (i == 99 ? in[0] : in[i+1]);
    end
endgenerate

endmodule