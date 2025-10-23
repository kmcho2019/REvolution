module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    wire carry_ones, carry_tens, carry_hundreds;

    // Combinational carry signals (detect if digit is 9)
    assign carry_ones     = (ones == 4'd9);
    assign carry_tens     = carry_ones && (tens == 4'd9);
    assign carry_hundreds = carry_tens && (hundreds == 4'd9);

    // Enable signals indicate when upper digits should increment
    assign ena = {carry_hundreds, carry_tens, carry_ones};

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment ones with carry rollover
            if (carry_ones)
                ones <= 4'd0;
            else
                ones <= ones + 1'b1;

            // Increment tens with carry rollover and enable
            if (carry_tens)
                tens <= 4'd0;
            else if (carry_ones)
                tens <= tens + 1'b1;

            // Increment hundreds with carry rollover and enable
            if (carry_hundreds)
                hundreds <= 4'd0;
            else if (carry_tens)
                hundreds <= hundreds + 1'b1;

            // Increment thousands with enable
            if (carry_hundreds) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 1'b1;
            end
        end
    end

    // Pack digits into output bus
    assign q = {thousands, hundreds, tens, ones};

endmodule