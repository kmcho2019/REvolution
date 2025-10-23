module freq_diveven #(
    parameter integer NUM_DIV = 4 // Must be an even number
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Synthesis-time check that NUM_DIV is even
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("Parameter NUM_DIV must be even. Given: %0d", NUM_DIV);
        end
    end

    // 4-bit counter sufficient for NUM_DIV up to 16; for larger NUM_DIV increase width
    reg [3:0] cnt;

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt     <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt     <= 4'd0;
                clk_div <= ~clk_div;  // Toggle on full count cycle completion
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule