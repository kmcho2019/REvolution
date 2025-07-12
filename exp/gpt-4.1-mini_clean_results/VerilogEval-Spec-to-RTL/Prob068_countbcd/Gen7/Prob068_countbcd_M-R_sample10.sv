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

    // Enable signals indicate when lower digits reach 9, so next digit increments
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    // Compute carry signals for each digit
    wire carry_ones      = (ones == 4'd9);
    wire carry_tens      = carry_ones && (tens == 4'd9);
    wire carry_hundreds  = carry_tens && (hundreds == 4'd9);

    // Compute next digit values based on carry
    wire [3:0] next_ones      = carry_ones      ? 4'd0 : ones + 1;
    wire [3:0] next_tens      = carry_ones      ? ((carry_tens)     ? 4'd0 : tens + 1) : tens;
    wire [3:0] next_hundreds  = carry_tens      ? ((carry_hundreds) ? 4'd0 : hundreds + 1) : hundreds;
    wire [3:0] next_thousands = carry_hundreds  ? ((thousands == 4'd9) ? 4'd0 : thousands + 1) : thousands;

    always @(posedge clk) begin
        if (reset)
            bcd_count <= 16'd0;
        else
            bcd_count <= {next_thousands, next_hundreds, next_tens, next_ones};
    end

    assign q = bcd_count;

endmodule