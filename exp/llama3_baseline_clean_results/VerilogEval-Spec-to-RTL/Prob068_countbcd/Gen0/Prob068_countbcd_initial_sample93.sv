module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    // Initialize internal signals for each digit of the BCD counter
    reg [3:0] q_ones, q_tens, q_hundreds, q_thousands;
    wire [3:0] next_q_ones, next_q_tens, next_q_hundreds, next_q_thousands;

    // Enable signals for each digit (ones place is always enabled)
    assign ena[0] = 1'b1; // Always enable the ones place
    reg ena_tens, ena_hundreds, ena_thousands;

    // Next state logic for the ones place
    assign next_q_ones = (q_ones == 4'd9)? 4'd0 : q_ones + 1;

    // Next state logic for the tens place (increment when ones place rolls over)
    assign next_q_tens = (ena_tens && (q_tens == 4'd9))? 4'd0 : (ena_tens? q_tens + 1 : q_tens);

    // Next state logic for the hundreds place (increment when tens place rolls over)
    assign next_q_hundreds = (ena_hundreds && (q_hundreds == 4'd9))? 4'd0 : (ena_hundreds? q_hundreds + 1 : q_hundreds);

    // Next state logic for the thousands place (increment when hundreds place rolls over)
    assign next_q_thousands = (ena_thousands && (q_thousands == 4'd9))? 4'd0 : (ena_thousands? q_thousands + 1 : q_thousands);

    // Enable signals for the tens, hundreds, and thousands places
    assign ena_tens = (q_ones == 4'd9);
    assign ena_hundreds = (q_tens == 4'd9 && ena_tens);
    assign ena_thousands = (q_hundreds == 4'd9 && ena_hundreds);

    // Output the enable signals
    assign ena[1] = ena_tens;
    assign ena[2] = ena_hundreds;

    // Output the BCD counter value
    assign q[3:0] = q_ones;
    assign q[7:4] = q_tens;
    assign q[11:8] = q_hundreds;
    assign q[15:12] = q_thousands;

    // Update the internal state on the positive edge of the clock
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all digits to 0
            q_ones <= 4'd0;
            q_tens <= 4'd0;
            q_hundreds <= 4'd0;
            q_thousands <= 4'd0;
        end else begin
            // Update the digits
            q_ones <= next_q_ones;
            q_tens <= next_q_tens;
            q_hundreds <= next_q_hundreds;
            q_thousands <= next_q_thousands;
        end
    end

endmodule