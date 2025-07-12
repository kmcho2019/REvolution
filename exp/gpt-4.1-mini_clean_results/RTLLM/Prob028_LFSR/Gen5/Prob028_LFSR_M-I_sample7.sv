module LFSR (
    input  wire       clk,
    input  wire       rst,      // Active high asynchronous reset
    output reg  [3:0] out
);

    wire feedback;

    // Feedback calculation: inversion of XOR of bits 3 and 2
    assign feedback = ~(out[3] ^ out[2]);

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 4'b0001;  // Non-zero seed on reset to avoid lock-up at zero
        end else begin
            out <= {out[2:0], feedback};  // Shift left, insert feedback
        end
    end

endmodule