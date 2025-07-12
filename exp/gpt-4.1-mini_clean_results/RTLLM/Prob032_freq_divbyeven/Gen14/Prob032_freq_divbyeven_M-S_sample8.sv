module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even >= 2
) (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Simple 4-bit counter sufficient for common even division values
    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == (NUM_DIV >> 1) - 1) begin
                cnt <= 0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule