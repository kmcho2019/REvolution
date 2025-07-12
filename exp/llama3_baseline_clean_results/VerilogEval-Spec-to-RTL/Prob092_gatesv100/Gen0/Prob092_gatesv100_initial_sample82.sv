module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// out_both: Check if current bit and its left neighbour are both '1'
always @(in) begin
    out_both[99] = 1'b0; // Most significant bit has no left neighbour
    for (int i = 98; i >= 0; i--) begin
        out_both[i] = in[i] & in[i+1];
    end
end

// out_any: Check if current bit or its right neighbour is '1'
always @(in) begin
    out_any[0] = 1'b0; // Least significant bit has no right neighbour
    for (int i = 1; i <= 99; i++) begin
        out_any[i] = in[i] | in[i-1];
    end
end

// out_different: Check if current bit is different from its left neighbour
always @(in) begin
    out_different[99] = in[99] ^ in[0]; // Wrap around to least significant bit
    for (int i = 98; i >= 0; i--) begin
        out_different[i] = in[i] ^ in[i+1];
    end
end

endmodule