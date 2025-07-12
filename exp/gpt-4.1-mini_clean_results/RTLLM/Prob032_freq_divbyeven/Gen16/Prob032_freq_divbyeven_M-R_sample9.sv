module freq_diveven #(
    parameter integer NUM_DIV = 4 // Must be even and >= 2
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameter check at elaboration
    initial begin
        if (NUM_DIV < 2 || (NUM_DIV % 2) != 0) begin
            $error("NUM_DIV parameter (%0d) must be even and >= 2", NUM_DIV);
        end
    end

    localparam integer MAX_COUNT = NUM_DIV - 1;
    localparam integer HALF_COUNT = NUM_DIV >> 1;

    reg [3:0] cnt = 4'd0;
    reg       clk_div_reg = 1'b0;

    // Counter logic: synchronous reset, counts 0 to MAX_COUNT
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 4'd0;
        end else if (cnt == MAX_COUNT) begin
            cnt <= 4'd0;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

    // Clock division toggle logic: toggle clk_div_reg at half count minus 1
    always @(posedge clk) begin
        if (!rst_n) begin
            clk_div_reg <= 1'b0;
        end else if (cnt == (HALF_COUNT - 1)) begin
            clk_div_reg <= ~clk_div_reg;
        end
    end

    assign clk_div = clk_div_reg;

endmodule