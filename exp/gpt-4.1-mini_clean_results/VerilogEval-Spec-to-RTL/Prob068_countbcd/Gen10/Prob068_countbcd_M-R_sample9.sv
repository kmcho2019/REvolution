module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] bcd_count;

    wire [3:0] ones      = bcd_count[3:0];
    wire [3:0] tens      = bcd_count[7:4];
    wire [3:0] hundreds  = bcd_count[11:8];
    wire [3:0] thousands = bcd_count[15:12];

    // Increment a BCD digit by 1 with carry-out combinationally
    // Returns next digit and carry out
    function [4:0] bcd_increment;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_increment = {1'b1, 4'd0};
            else
                bcd_increment = {1'b0, digit + 1'b1};
        end
    endfunction

    // Calculate increment results for each digit combinationally
    wire [4:0] ones_inc      = bcd_increment(ones);
    wire [4:0] tens_inc;
    wire [4:0] hundreds_inc;
    wire [4:0] thousands_inc;

    // Carry chain propagation for the next values
    assign tens_inc      = bcd_increment(tens);
    assign hundreds_inc  = bcd_increment(hundreds);
    assign thousands_inc = bcd_increment(thousands);

    // Propagate carries accordingly
    // If ones carry out, tens increments, else tens stays same
    wire carry_ones  = ones_inc[4];
    wire carry_tens  = (carry_ones) ? tens_inc[4] : 1'b0;
    wire carry_hundreds = (carry_tens) ? hundreds_inc[4] : 1'b0;

    // Next digit values based on carry chain
    wire [3:0] next_ones      = ones_inc[3:0];
    wire [3:0] next_tens      = (carry_ones) ? tens_inc[3:0] : tens;
    wire [3:0] next_hundreds  = (carry_tens) ? hundreds_inc[3:0] : hundreds;
    wire [3:0] next_thousands = (carry_hundreds) ? thousands_inc[3:0] : thousands;

    // Output enables: when the lower digit rolls over (carry out), the upper digit should increment
    assign ena[0] = carry_ones;     // enable for tens digit increment
    assign ena[1] = carry_tens;     // enable for hundreds digit increment
    assign ena[2] = carry_hundreds; // enable for thousands digit increment

    always @(posedge clk) begin
        if (reset) begin
            bcd_count <= 16'd0;
        end else begin
            bcd_count <= {next_thousands, next_hundreds, next_tens, next_ones};
        end
    end

    assign q = bcd_count;

endmodule