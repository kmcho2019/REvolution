module TopModule (
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones, tens, hundreds, thousands;
reg [2:0] ena_reg;
reg [15:0] q_reg;

assign ena = ena_reg;
assign q = q_reg;

always @(posedge clk) begin
    if (reset) begin
        ones <= 4'b0000;
        tens <= 4'b0000;
        hundreds <= 4'b0000;
        thousands <= 4'b0000;
    end else begin
        if (ones == 4'b1001) begin
            ones <= 4'b0000;
            ena_reg[0] <= 1'b1;
            if (tens == 4'b1001) begin
                tens <= 4'b0000;
                ena_reg[1] <= 1'b1;
                if (hundreds == 4'b1001) begin
                    hundreds <= 4'b0000;
                    ena_reg[2] <= 1'b1;
                    if (thousands == 4'b1001) begin
                        thousands <= 4'b0000;
                    end else begin
                        thousands <= thousands + 1;
                    end
                end else begin
                    hundreds <= hundreds + 1;
                    ena_reg[2] <= 1'b0;
                end
            end else begin
                tens <= tens + 1;
                ena_reg[1] <= 1'b0;
            end
        end else begin
            ones <= ones + 1;
            ena_reg[0] <= 1'b0;
        end
        ena_reg <= {ena_reg[2:1], ena_reg[0]} << 1;
    end
    q_reg <= {thousands, hundreds, tens, ones};
end

endmodule