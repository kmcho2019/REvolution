module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Check that NUM_DIV is even and at least 2
    initial begin
        if (NUM_DIV < 2 || (NUM_DIV % 2) != 0) begin
            $error("NUM_DIV parameter (%0d) must be even and >= 2", NUM_DIV);
        end
    end

    // Half period count for toggling
    localparam integer HALF_PERIOD = NUM_DIV >> 1;

    reg [3:0] cnt = 0;
    reg       clk_div_reg = 0;

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div_reg <= 0;
        end else begin
            if (cnt == HALF_PERIOD - 1) begin
                cnt <= 0;
                clk_div_reg <= ~clk_div_reg;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

    assign clk_div = clk_div_reg;

endmodule