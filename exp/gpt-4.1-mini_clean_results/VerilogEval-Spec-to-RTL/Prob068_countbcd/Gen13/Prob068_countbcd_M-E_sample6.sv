module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] bcd_count;  // 4-digit BCD counter: [15:12] thousands, [11:8] hundreds, [7:4] tens, [3:0] ones
    wire [15:0] next_count;
    wire inc_ones_rollover, inc_tens_rollover, inc_hundreds_rollover;

    // BCD Incrementer function: increments a 4-bit digit, rolls over from 9 to 0
    function [3:0] bcd_inc;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_inc = 4'd0;
            else
                bcd_inc = digit + 4'd1;
        end
    endfunction

    // Compute next BCD value combinationally
    // Start from ones digit, carry ripple to upper digits if needed
    wire ones_roll = (bcd_count[3:0] == 4'd9);
    wire tens_roll = (bcd_count[7:4] == 4'd9) && ones_roll;
    wire hundreds_roll = (bcd_count[11:8] == 4'd9) && tens_roll;

    // Increment logic using the carries
    wire [3:0] next_ones = bcd_inc(bcd_count[3:0]);
    wire [3:0] next_tens = (ones_roll) ? bcd_inc(bcd_count[7:4]) : bcd_count[7:4];
    wire [3:0] next_hundreds = (tens_roll) ? bcd_inc(bcd_count[11:8]) : bcd_count[11:8];
    wire [3:0] next_thousands = (hundreds_roll) ? ((bcd_count[15:12] == 4'd9) ? 4'd0 : bcd_count[15:12] + 4'd1) : bcd_count[15:12];

    assign next_count = {next_thousands, next_hundreds, next_tens, next_ones};

    // Enables generated combinationally based on carry out conditions:
    // ena[0]: enable tens digit increment (when ones digit rolls over)
    // ena[1]: enable hundreds digit increment (when tens digit rolls over)
    // ena[2]: enable thousands digit increment (when hundreds digit rolls over)
    assign ena[0] = ones_roll;
    assign ena[1] = tens_roll;
    assign ena[2] = hundreds_roll;

    always @(posedge clk) begin
        if (reset)
            bcd_count <= 16'd0;
        else
            bcd_count <= next_count;
    end

    assign q = bcd_count;

endmodule