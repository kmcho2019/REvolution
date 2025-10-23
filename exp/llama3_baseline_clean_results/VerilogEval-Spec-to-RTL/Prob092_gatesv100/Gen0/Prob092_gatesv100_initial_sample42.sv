module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// out_both: set to '1' if both the current bit and its left neighbor are '1'
// for the most significant bit (in[99]), there is no left neighbor, so set out_both[99] to '0'
always @(*) begin
    out_both[99] = 1'b0;
    for (int i = 98; i >= 0; i--) begin
        out_both[i] = in[i] & in[i+1];
    end
end

// out_any: set to '1' if either the current bit or its right neighbor is '1'
// for the least significant bit (in[0]), there is no right neighbor, so set out_any[0] to '0'
always @(*) begin
    out_any[0] = 1'b0;
    for (int i = 1; i <= 99; i++) begin
        out_any[i] = in[i] | in[i-1];
    end
end

// out_different: set to '1' if the current bit is different from its left neighbor
// for the most significant bit (in[99]), its left neighbor is the least significant bit (in[0])
always @(*) begin
    out_different[99] = in[99] ^ in[0];
    for (int i = 98; i >= 0; i--) begin
        out_different[i] = in[i] ^ in[i+1];
    end
end

endmodule