module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    wire [3:0] ones = counter[3:0];
    wire [3:0] tens = counter[7:4];
    wire [3:0] hundreds = counter[11:8];
    wire [3:0] thousands = counter[15:12];

    // Enable signals
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (ones == 4'd9) & (tens == 4'd9);
    assign ena[2] = (ones == 4'd9) & (tens == 4'd9) & (hundreds == 4'd9);

    // Next state logic
    wire [15:0] next_counter = reset ? 16'd0 : 
        (ones != 4'd9) ? counter + 1 :
        (tens != 4'd9) ? counter + 16'h7 :  // +7 because 9->0 is -9, +1 is -8, +7 gives +16'h10
        (hundreds != 4'd9) ? counter + 16'h67 :  // +103 (0x67) to roll over tens and ones
        (thousands != 4'd9) ? counter + 16'h667 :  // +1639 (0x667) to roll over hundreds, tens, ones
        counter + 16'h1;  // roll over all digits (9999 -> 0000)

    assign q = counter;

    always @(posedge clk) begin
        counter <= next_counter;
    end

endmodule