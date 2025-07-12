module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be an even number
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // 4-bit counter as required
    reg [3:0] cnt;

    // Synthesis-time check for even NUM_DIV (non-zero)
    initial begin
        if (NUM_DIV == 0 || (NUM_DIV % 2) != 0) begin
            $error("Parameter NUM_DIV must be a non-zero even number.");
        end
        if (NUM_DIV > 16) begin
            $warning("NUM_DIV exceeds 16, counter width might be insufficient.");
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 4'b0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt     <= 4'b0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule