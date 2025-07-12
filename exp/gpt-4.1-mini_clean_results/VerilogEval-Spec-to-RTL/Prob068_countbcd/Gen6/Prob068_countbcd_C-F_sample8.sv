module TopModule (
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Combinational carry signals indicating digit rollovers
    wire carry_0 = (ones == 4'd9);
    wire carry_1 = carry_0 && (tens == 4'd9);
    wire carry_2 = carry_1 && (hundreds == 4'd9);

    // ena output signals reflect increment enables for tens, hundreds, thousands digits
    // Directly from carry signals to be combinational and immediate
    assign ena = {carry_2, carry_1, carry_0};

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment ones digit every cycle, reset to 0 on rollover
            if (carry_0)
                ones <= 4'd0;
            else
                ones <= ones + 4'd1;

            // Increment tens digit only when ones roll over
            if (carry_0) begin
                if (carry_1)
                    tens <= 4'd0;
                else
                    tens <= tens + 4'd1;
            end

            // Increment hundreds digit only when tens roll over
            if (carry_1) begin
                if (carry_2)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 4'd1;
            end

            // Increment thousands digit only when hundreds roll over
            if (carry_2) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 4'd1;
            end
        end
    end

    // Concatenate digits to form 16-bit BCD output: {thousands, hundreds, tens, ones}
    assign q = {thousands, hundreds, tens, ones};

endmodule