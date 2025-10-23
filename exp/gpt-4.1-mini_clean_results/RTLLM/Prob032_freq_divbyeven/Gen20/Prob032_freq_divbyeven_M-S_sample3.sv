module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Check that NUM_DIV is even at compile time
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("NUM_DIV must be even. Given: %0d", NUM_DIV);
        end
    end

    reg [3:0] cnt;  // 4-bit counter

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 0;
        end else if (cnt == (NUM_DIV/2 - 1)) begin
            cnt     <= 0;
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1;
        end
    end

endmodule