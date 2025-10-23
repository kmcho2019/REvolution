module TopModule (
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Determine carry signals combinationally
    wire carry_0 = (ones == 4'd9);
    wire carry_1 = carry_0 && (tens == 4'd9);
    wire carry_2 = carry_1 && (hundreds == 4'd9);
    wire carry_3 = carry_2 && (thousands == 4'd9);

    // Calculate next digit values combinationally
    wire [3:0] next_ones      = carry_0 ? 4'd0 : (ones + 4'd1);
    wire [3:0] next_tens      = carry_0 ? (carry_1 ? 4'd0 : tens + 4'd1) : tens;
    wire [3:0] next_hundreds  = carry_1 ? (carry_2 ? 4'd0 : hundreds + 4'd1) : hundreds;
    wire [3:0] next_thousands = carry_2 ? (carry_3 ? 4'd0 : thousands + 4'd1) : thousands;

    // 'ena' indicates when tens, hundreds, thousands digits should increment
    assign ena = {carry_2, carry_1, carry_0};

    // Synchronous digit update with synchronous active-high reset
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

    // Concatenate digits for 16-bit BCD output
    assign q = {thousands, hundreds, tens, ones};

endmodule