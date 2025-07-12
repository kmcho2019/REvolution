module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;

    assign q = {thousands, hundreds, tens, ones};

    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'b0000;
            tens <= 4'b0000;
            hundreds <= 4'b0000;
            thousands <= 4'b0000;
        end else begin
            ones <= ones + 1;
            if (ones == 4'b1001) begin
                ones <= 4'b0000;
                tens <= tens + 1;
                if (tens == 4'b1001) begin
                    tens <= 4'b0000;
                    hundreds <= hundreds + 1;
                    if (hundreds == 4'b1001) begin
                        hundreds <= 4'b0000;
                        thousands <= thousands + 1;
                    end
                end
            end
        end
    end

    assign ena[0] = (ones == 4'b1001) ? 1'b1 : 1'b0;
    assign ena[1] = (tens == 4'b1001 && ones == 4'b1001) ? 1'b1 : 1'b0;
    assign ena[2] = (hundreds == 4'b1001 && tens == 4'b1001 && ones == 4'b1001) ? 1'b1 : 1'b0;

endmodule