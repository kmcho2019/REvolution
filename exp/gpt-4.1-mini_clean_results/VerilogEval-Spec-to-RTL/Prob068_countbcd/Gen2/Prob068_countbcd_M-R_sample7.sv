module TopModule (
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Combinational wires for carry signals and next digit values
    wire carry_0, carry_1, carry_2, carry_3;
    wire [3:0] next_ones, next_tens, next_hundreds, next_thousands;

    // Compute carry and next values for ones digit
    assign carry_0 = (ones == 4'd9);
    assign next_ones = carry_0 ? 4'd0 : (ones + 4'd1);

    // Compute carry and next values for tens digit
    assign carry_1 = (tens == 4'd9) && carry_0;
    assign next_tens = carry_0 ? (carry_1 ? 4'd0 : tens + 4'd1) : tens;

    // Compute carry and next values for hundreds digit
    assign carry_2 = (hundreds == 4'd9) && carry_1;
    assign next_hundreds = carry_1 ? (carry_2 ? 4'd0 : hundreds + 4'd1) : hundreds;

    // Compute carry and next values for thousands digit
    assign carry_3 = (thousands == 4'd9) && carry_2;
    assign next_thousands = carry_2 ? (carry_3 ? 4'd0 : thousands + 4'd1) : thousands;

    // ena signals indicate when tens, hundreds, thousands digits should increment
    assign ena = {carry_2, carry_1, carry_0};

    // Update the digits on the clock edge with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            ones      <= next_ones;
            tens      <= next_tens;
            hundreds  <= next_hundreds;
            thousands <= next_thousands;
        end
    end

    // Output concatenated BCD digits
    assign q = {thousands, hundreds, tens, ones};

endmodule