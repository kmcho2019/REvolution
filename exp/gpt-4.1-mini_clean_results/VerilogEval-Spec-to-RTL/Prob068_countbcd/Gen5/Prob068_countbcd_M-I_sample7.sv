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

    // Determine carry from ones digit
    assign carry_0 = (ones == 4'd9);

    // Determine carry from tens digit (only valid if tens incremented)
    assign carry_1 = (tens == 4'd9) && carry_0;

    // Determine carry from hundreds digit (only valid if hundreds incremented)
    assign carry_2 = (hundreds == 4'd9) && carry_1;

    // ena signals: indicate when tens, hundreds, thousands digits should increment
    // This matches carry out signals for lower digit roll-over events
    assign ena = {carry_2, carry_1, carry_0};

    // Sequential update logic with enables
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

            // Tens digit increments only when ones roll over
            if (carry_0) begin
                if (carry_1)
                    tens <= 4'd0;
                else
                    tens <= tens + 4'd1;
            end

            // Hundreds digit increments only when tens roll over
            if (carry_1) begin
                if (carry_2)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 4'd1;
            end

            // Thousands digit increments only when hundreds roll over
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