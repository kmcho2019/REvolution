module TopModule(
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    wire [3:0] ones_next, tens_next, hundreds_next, thousands_next;
    reg [2:0] ena_reg;

    assign q = {thousands, hundreds, tens, ones};

    // Next state logic for each digit
    assign ones_next = (ones == 4'd9)? 4'd0 : ones + 1'd1;
    assign tens_next = (ones == 4'd9)? (tens == 4'd9)? 4'd0 : tens + 1'd1 : tens;
    assign hundreds_next = (tens == 4'd9 && ones == 4'd0)? (hundreds == 4'd9)? 4'd0 : hundreds + 1'd1 : hundreds;
    assign thousands_next = (hundreds == 4'd9 && tens == 4'd0 && ones == 4'd0)? (thousands == 4'd9)? 4'd0 : thousands + 1'd1 : thousands;

    // Enable signals for upper three digits
    assign ena[0] = (ones == 4'd9)? 1'd1 : 1'd0;
    assign ena[1] = (tens == 4'd9 && ones == 4'd0)? 1'd1 : 1'd0;
    assign ena[2] = (hundreds == 4'd9 && tens == 4'd0 && ones == 4'd0)? 1'd1 : 1'd0;

    // Synchronous reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            ena_reg <= 3'd0;
        end else begin
            ones <= ones_next;
            tens <= tens_next;
            hundreds <= hundreds_next;
            thousands <= thousands_next;
            ena_reg <= {ena[2], ena[1], ena[0]};
        end
    end

    assign ena = ena_reg;

endmodule