module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] count;

    wire [3:0] ones     = count[3:0];
    wire [3:0] tens     = count[7:4];
    wire [3:0] hundreds = count[11:8];
    wire [3:0] thousands= count[15:12];

    // Compute carry signals for each digit increment
    wire ones_rollover      = (ones == 4'd9);
    wire tens_rollover      = (tens == 4'd9);
    wire hundreds_rollover  = (hundreds == 4'd9);
    wire thousands_rollover = (thousands == 4'd9);

    // Compute next value for each digit
    wire [3:0] next_ones = (ones_rollover) ? 4'd0 : (ones + 4'd1);

    wire [3:0] next_tens = (ones_rollover)
                            ? ((tens_rollover) ? 4'd0 : (tens + 4'd1))
                            : tens;

    wire [3:0] next_hundreds = (ones_rollover && tens_rollover)
                               ? ((hundreds_rollover) ? 4'd0 : (hundreds + 4'd1))
                               : hundreds;

    wire [3:0] next_thousands = (ones_rollover && tens_rollover && hundreds_rollover)
                                ? ((thousands_rollover) ? 4'd0 : (thousands + 4'd1))
                                : thousands;

    wire [15:0] next_count = {next_thousands, next_hundreds, next_tens, next_ones};

    always @(posedge clk) begin
        if (reset)
            count <= 16'd0;
        else
            count <= next_count;
    end

    // ena signals indicate when the corresponding digit should be incremented
    // that is, when the lower digit(s) reach 9
    assign ena[0] = ones_rollover;                          // tens increments if ones == 9
    assign ena[1] = ones_rollover && tens_rollover;         // hundreds increments if ones and tens == 9
    assign ena[2] = ones_rollover && tens_rollover && hundreds_rollover; // thousands increments if ones, tens, hundreds == 9

    assign q = count;

endmodule