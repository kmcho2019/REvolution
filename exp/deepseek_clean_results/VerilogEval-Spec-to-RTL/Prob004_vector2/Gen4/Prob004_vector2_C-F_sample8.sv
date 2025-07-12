module TopModule #(parameter WIDTH = 32) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    // For 32-bit vectors, use optimal direct concatenation
    generate
        if (WIDTH == 32) begin
            assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};
        end
        // Could add other width cases here if needed
        else begin
            assign out = in; // Default case (no byte reversal)
        end
    endgenerate
endmodule