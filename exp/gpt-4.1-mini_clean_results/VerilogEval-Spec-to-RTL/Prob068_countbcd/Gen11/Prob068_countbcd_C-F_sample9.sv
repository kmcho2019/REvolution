module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] bcd_count;

    // Extract digits
    wire [3:0] ones      = bcd_count[3:0];
    wire [3:0] tens      = bcd_count[7:4];
    wire [3:0] hundreds  = bcd_count[11:8];
    wire [3:0] thousands = bcd_count[15:12];

    // Generate enable signals for upper digit increments:
    // ena[0]: tens increments when ones == 9 (rolling over)
    // ena[1]: hundreds increments when tens == 9 and ones == 9
    // ena[2]: thousands increments when hundreds == 9 and tens == 9 and ones == 9
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    // Function: Increment BCD digit with carry out
    function [4:0] bcd_inc;
        input [3:0] digit_in;
        begin
            if (digit_in == 4'd9)
                bcd_inc = {1'b1, 4'd0}; // carry out with digit reset to 0
            else
                bcd_inc = {1'b0, digit_in + 1'b1};
        end
    endfunction

    // Compute next digits combinationally before register update to flatten carry logic
    wire carry_ones;
    wire carry_tens;
    wire carry_hundreds;
    wire carry_thousands;

    wire [3:0] next_ones;
    wire [3:0] next_tens;
    wire [3:0] next_hundreds;
    wire [3:0] next_thousands;

    wire [4:0] inc_ones;
    wire [4:0] inc_tens;
    wire [4:0] inc_hundreds;
    wire [4:0] inc_thousands;

    assign inc_ones = bcd_inc(ones);
    assign carry_ones = inc_ones[4];
    assign next_ones = inc_ones[3:0];

    assign inc_tens = carry_ones ? bcd_inc(tens) : {1'b0, tens};
    assign carry_tens = inc_tens[4];
    assign next_tens = inc_tens[3:0];

    assign inc_hundreds = carry_tens ? bcd_inc(hundreds) : {1'b0, hundreds};
    assign carry_hundreds = inc_hundreds[4];
    assign next_hundreds = inc_hundreds[3:0];

    assign inc_thousands = carry_hundreds ? bcd_inc(thousands) : {1'b0, thousands};
    assign carry_thousands = inc_thousands[4];
    assign next_thousands = inc_thousands[3:0];

    // Sequential update
    always @(posedge clk) begin
        if (reset) begin
            bcd_count <= 16'd0;
        end else begin
            bcd_count <= {next_thousands, next_hundreds, next_tens, next_ones};
        end
    end

    assign q = bcd_count;

endmodule