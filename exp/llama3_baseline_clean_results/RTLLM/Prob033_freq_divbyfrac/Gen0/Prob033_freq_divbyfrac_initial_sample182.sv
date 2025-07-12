module freq_divbyfrac(
    input  clk,
    input  rst_n,
    output reg clk_div
);

localparam MUL2_DIV_CLK = 7;

reg [2:0] count;
reg div_clk1, div_clk2;
reg div_clk1_shift, div_clk2_shift;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 3'b000;
        div_clk1 <= 1'b0;
        div_clk2 <= 1'b0;
        div_clk1_shift <= 1'b0;
        div_clk2_shift <= 1'b0;
    end else begin
        if (count == 3'b110) begin
            count <= 3'b000;
            div_clk1 <= 1'b1;
            div_clk2 <= 1'b0;
        end else if (count == 3'b101) begin
            count <= count + 1;
            div_clk1 <= 1'b0;
            div_clk2 <= 1'b0;
        end else if (count == 3'b100) begin
            count <= count + 1;
            div_clk1 <= 1'b0;
            div_clk2 <= 1'b1;
        end else if (count == 3'b011) begin
            count <= count + 1;
            div_clk1 <= 1'b1;
            div_clk2 <= 1'b0;
        end else if (count == 3'b010) begin
            count <= count + 1;
            div_clk1 <= 1'b1;
            div_clk2 <= 1'b0;
        end else if (count == 3'b001) begin
            count <= count + 1;
            div_clk1 <= 1'b0;
            div_clk2 <= 1'b1;
        end else begin
            count <= count + 1;
            div_clk1 <= 1'b0;
            div_clk2 <= 1'b1;
        end
    end
end

always_comb begin
    div_clk1_shift = div_clk1;
    div_clk2_shift = div_clk2;
    if (count == 3'b110) begin
        div_clk1_shift = 1'b1;
        div_clk2_shift = 1'b0;
    end else if (count == 3'b101) begin
        div_clk1_shift = 1'b0;
        div_clk2_shift = 1'b1;
    end else if (count == 3'b100) begin
        div_clk1_shift = 1'b0;
        div_clk2_shift = 1'b0;
    end else if (count == 3'b011) begin
        div_clk1_shift = 1'b1;
        div_clk2_shift = 1'b0;
    end else if (count == 3'b010) begin
        div_clk1_shift = 1'b1;
        div_clk2_shift = 1'b0;
    end else if (count == 3'b001) begin
        div_clk1_shift = 1'b0;
        div_clk2_shift = 1'b1;
    end else begin
        div_clk1_shift = 1'b0;
        div_clk2_shift = 1'b0;
    end
end

assign clk_div = div_clk1_shift | div_clk2_shift;

endmodule