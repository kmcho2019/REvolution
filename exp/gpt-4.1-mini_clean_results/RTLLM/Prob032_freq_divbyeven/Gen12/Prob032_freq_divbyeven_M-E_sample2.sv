module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    reg [3:0] cnt;

    // Count clock cycles up to half of NUM_DIV
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 4'd0;
        end else if (cnt == (NUM_DIV >> 1) - 1) begin
            cnt <= 4'd0;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

    // Toggle clk_div when counter reaches half of NUM_DIV - 1
    always @(posedge clk) begin
        if (!rst_n) begin
            clk_div <= 1'b0;
        end else if (cnt == (NUM_DIV >> 1) - 1) begin
            clk_div <= ~clk_div;
        end
    end

endmodule