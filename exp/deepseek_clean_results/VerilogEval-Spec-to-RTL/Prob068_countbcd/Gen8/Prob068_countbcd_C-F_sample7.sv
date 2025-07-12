module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    
    // Parallel overflow detection
    wire ones_ov = (ones == 4'd9);
    wire tens_ov = (tens == 4'd9);
    wire hundreds_ov = (hundreds == 4'd9);
    
    // Enable signals (parallel computation)
    assign ena[0] = ones_ov;
    assign ena[1] = ones_ov & tens_ov;
    assign ena[2] = ones_ov & tens_ov & hundreds_ov;
    
    // Next state computation (parallel, masked)
    wire [3:0] next_ones = reset ? 4'd0 : (ones + !ones_ov);
    wire [3:0] next_tens = reset ? 4'd0 : tens + (ena[0] & !(ena[0] & tens_ov));
    wire [3:0] next_hundreds = reset ? 4'd0 : hundreds + (ena[1] & !(ena[1] & hundreds_ov));
    wire [3:0] next_thousands = reset ? 4'd0 : thousands + (ena[2] & !(ena[2] & (thousands == 4'd9)));

    always @(posedge clk) begin
        ones <= next_ones;
        tens <= next_tens;
        hundreds <= next_hundreds;
        thousands <= next_thousands;
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule