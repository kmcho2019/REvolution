module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;
    reg [2:0] ena_reg;

    assign q = {thousands, hundreds, tens, ones};
    assign ena = ena_reg;

    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            ones <= 0;
            tens <= 0;
            hundreds <= 0;
            thousands <= 0;
            ena_reg <= 0;
        end else begin
            ena_reg <= 0;

            if (ones == 9) begin
                ones <= 0;
                ena_reg[0] <= 1;
                if (tens == 9) begin
                    tens <= 0;
                    ena_reg[1] <= 1;
                    if (hundreds == 9) begin
                        hundreds <= 0;
                        ena_reg[2] <= 1;
                        if (thousands == 9) begin
                            thousands <= 0;
                        end else begin
                            thousands <= thousands + 1;
                        end
                    end else begin
                        hundreds <= hundreds + 1;
                    end
                end else begin
                    tens <= tens + 1;
                end
            end else begin
                ones <= ones + 1;
            end
        end
    end

endmodule