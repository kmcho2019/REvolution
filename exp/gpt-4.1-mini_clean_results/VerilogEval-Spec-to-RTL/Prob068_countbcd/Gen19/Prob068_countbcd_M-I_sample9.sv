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

    // Compute carry and next digit for each BCD digit in combinational logic
    // Increment ones digit always by 1
    wire carry_ones = (ones == 4'd9);
    wire [3:0] ones_next = carry_ones ? 4'd0 : (ones + 1);

    // Enable signals for upper digits increment (output ena)
    assign ena[0] = carry_ones;                                    // tens increment enable
    assign ena[1] = ena[0] & (tens == 4'd9);                      // hundreds increment enable
    assign ena[2] = ena[1] & (hundreds == 4'd9);                  // thousands increment enable

    wire carry_tens = (tens == 4'd9) & carry_ones;
    wire [3:0] tens_next = carry_ones ? (carry_tens ? 4'd0 : tens + 1) : tens;

    wire carry_hundreds = (hundreds == 4'd9) & carry_tens;
    wire [3:0] hundreds_next = carry_tens ? (carry_hundreds ? 4'd0 : hundreds + 1) : hundreds;

    wire carry_thousands = (thousands == 4'd9) & carry_hundreds;
    wire [3:0] thousands_next = carry_hundreds ? (carry_thousands ? 4'd0 : thousands + 1) : thousands;

    always @(posedge clk) begin
        if (reset)
            bcd_count <= 16'd0;
        else
            bcd_count <= {thousands_next, hundreds_next, tens_next, ones_next};
    end

    assign q = bcd_count;

endmodule