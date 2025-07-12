module TopModule #(
    parameter WIDTH = 32,
    parameter BYTE_SIZE = 8
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    // Check if width is exactly 4 bytes (32 bits)
    generate
        if (WIDTH == 32 && BYTE_SIZE == 8) begin
            // Optimal direct concatenation for 32-bit vectors
            assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};
        end
        else if (WIDTH % BYTE_SIZE == 0) begin
            // Generalized byte reversal for any multiple of byte size
            integer i;
            for (i = 0; i < WIDTH/BYTE_SIZE; i = i + 1) begin
                assign out[i*BYTE_SIZE +: BYTE_SIZE] = in[(WIDTH-(i+1)*BYTE_SIZE) +: BYTE_SIZE];
            end
        end
        else begin
            // Default case - pass through with warning
            assign out = in;
            initial $display("Warning: Input width %0d not a multiple of byte size %0d", WIDTH, BYTE_SIZE);
        end
    endgenerate
endmodule