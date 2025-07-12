module TopModule(
    input         clk,
    input         reset,
    output  [2:0] ena,
    output [15:0] q
);

reg [3:0] ones, tens, hundreds, thousands;
reg [2:0] ena_reg;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        ones <= 4'b0000;
        tens <= 4'b0000;
        hundreds <= 4'b0000;
        thousands <= 4'b0000;
        ena_reg <= 3'b000;
    end else begin
        ena_reg <= 3'b000;
        if(ones == 4'b1001) begin
            ones <= 4'b0000;
            ena_reg[0] <= 1'b0;
            if(tens == 4'b1001) begin
                tens <= 4'b0000;
                ena_reg[1] <= 1'b0;
                if(hundreds == 4'b1001) begin
                    hundreds <= 4'b0000;
                    ena_reg[2] <= 1'b0;
                    thousands <= thousands + 1'b1;
                    ena_reg[2] <= 1'b1;
                end else begin
                    hundreds <= hundreds + 1'b1;
                    ena_reg[2] <= 1'b0;
                    ena_reg[1] <= 1'b1;
                end
            end else begin
                tens <= tens + 1'b1;
                ena_reg[1] <= 1'b0;
                ena_reg[0] <= 1'b1;
            end
        end else begin
            ones <= ones + 1'b1;
            ena_reg[0] <= 1'b1;
        end
    end
end

assign ena = ena_reg;
assign q = {thousands, hundreds, tens, ones};

endmodule