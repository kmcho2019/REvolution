module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// out_both: each bit is 1 if the corresponding input bit and its neighbor to the left are both 1
// out_both[99] is 0 since in[99] has no neighbor to the left
always @(*) begin
    out_both[99] = 1'b0;
    for (int i = 98; i >= 0; i--) begin
        out_both[i] = in[i] & in[i+1];
    end
end

// out_any: each bit is 1 if the corresponding input bit or its neighbor to the right is 1
// out_any[0] is 0 since in[0] has no neighbor to the right
always @(*) begin
    out_any[0] = 1'b0;
    for (int i = 1; i <= 99; i++) begin
        out_any[i] = in[i] | in[i-1];
    end
end

// out_different: each bit is 1 if the corresponding input bit is different from its neighbor to the left
// wrapping around to the start of the vector for in[99]
always @(*) begin
    for (int i = 98; i >= 0; i--) begin
        out_different[i] = ~(in[i] ^ in[i+1]);
    end
    out_different[99] = ~(in[99] ^ in[0]);
end

endmodule