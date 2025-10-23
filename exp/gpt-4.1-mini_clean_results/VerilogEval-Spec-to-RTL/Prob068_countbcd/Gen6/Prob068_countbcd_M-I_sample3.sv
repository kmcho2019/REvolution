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

    // Per-digit enables for register update (ones always enabled)
    wire ena_ones = 1'b1;
    wire ena_tens = carry_0;
    wire ena_hundreds = carry_1;
    wire ena_thousands = carry_2;

    // Synchronous digit update with synchronous active-high reset and per-digit enable
    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            if (ena_ones)
                ones <= next_ones;
            if (ena_tens)
                tens <= next_tens;
            if (ena_hundreds)
                hundreds <= next_hundreds;
            if (ena_thousands)
                thousands <= next_thousands;
        end
    end

    // Concatenate digits for 16-bit BCD output
    assign q = {thousands, hundreds, tens, ones};

endmodule