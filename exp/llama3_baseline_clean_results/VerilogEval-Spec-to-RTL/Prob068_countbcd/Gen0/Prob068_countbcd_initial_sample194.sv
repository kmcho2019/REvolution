module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones, tens, hundreds, thousands;
reg [2:0] ena_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ones <= 0;
        tens <= 0;
        hundreds <= 0;
        thousands <= 0;
        ena_reg <= 0;
    end else begin
        if (ones == 4'd9) begin
            ones <= 0;
            if (tens == 4'd9) begin
                tens <= 0;
                if (hundreds == 4'd9) begin
                    hundreds <= 0;
                    thousands <= thousands + 1;
                    ena_reg[2] <= 1'b1;
                end else begin
                    hundreds <= hundreds + 1;
                    ena_reg[1] <= 1'b1;
                end
                ena_reg[0] <= 1'b1;
            end else begin
                tens <= tens + 1;
                ena_reg[0] <= 1'b1;
            end
        end else begin
            ones <= ones + 1;
        end
        if (~(&ones[3:0])) begin
            ena_reg <= 3'b0;
        end
    end
end

assign ena = ena_reg;
assign q = {thousands, hundreds, tens, ones};

endmodule