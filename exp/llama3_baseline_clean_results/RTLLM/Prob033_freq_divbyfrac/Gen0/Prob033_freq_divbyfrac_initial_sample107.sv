module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter MUL2_DIV_CLK = 7;

reg [2:0] counter;
reg clk_div_int1, clk_div_int2;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
            clk_div_int1 <= ~clk_div_int1;
            clk_div_int2 <= ~clk_div_int2;
        end else begin
            counter <= counter + 1;
        end

        if ((counter == 3'b100) || (counter == 3'b011)) begin
            clk_div_int1 <= ~clk_div_int1;
        end

        if ((counter == 3'b010) || (counter == 3'b101)) begin
            clk_div_int2 <= ~clk_div_int2;
        end
    end
end

always @ (posedge clk_div_int1 or posedge clk_div_int2) begin
    clk_div <= clk_div_int1 || clk_div_int2;
end

endmodule