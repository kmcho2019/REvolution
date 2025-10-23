module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    wire c1, c2, c3;

    // Carry signals combinationally derived
    assign c1 = (ones == 4'd9);
    assign c2 = c1 && (tens == 4'd9);
    assign c3 = c2 && (hundreds == 4'd9);

    // Enable signals for upper digit increments
    assign ena = {c3, c2, c1};

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment ones digit and generate carry
            if (c1)
                ones <= 4'd0;
            else
                ones <= ones + 1'b1;

            // Increment tens digit if carry from ones
            if (c1) begin
                if (c2)
                    tens <= 4'd0;
                else
                    tens <= tens + 1'b1;
            end

            // Increment hundreds digit if carry from tens
            if (c2) begin
                if (c3)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 1'b1;
            end

            // Increment thousands digit if carry from hundreds
            if (c3) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 1'b1;
            end
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule