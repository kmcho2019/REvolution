module TopModule (
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    wire carry_0; // carry from ones to tens
    wire carry_1; // carry from tens to hundreds
    wire carry_2; // carry from hundreds to thousands

    // Ones digit carry: true when ones is 9 before incrementing
    assign carry_0 = (ones == 4'd9);

    // Tens digit carry: true when tens is 9 and carry_0 is asserted
    assign carry_1 = carry_0 & (tens == 4'd9);

    // Hundreds digit carry: true when hundreds is 9 and carry_1 is asserted
    assign carry_2 = carry_1 & (hundreds == 4'd9);

    // ena signals indicate when each upper digit increments
    assign ena = {carry_2, carry_1, carry_0};

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Ones digit always increments
            if (carry_0)
                ones <= 4'd0;
            else
                ones <= ones + 4'd1;

            // Tens digit increments only when carry from ones digit
            if (carry_0) begin
                if (carry_1)
                    tens <= 4'd0;
                else
                    tens <= tens + 4'd1;
            end

            // Hundreds digit increments only when carry from tens digit
            if (carry_1) begin
                if (carry_2)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 4'd1;
            end

            // Thousands digit increments only when carry from hundreds digit
            if (carry_2) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 4'd1;
            end
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule