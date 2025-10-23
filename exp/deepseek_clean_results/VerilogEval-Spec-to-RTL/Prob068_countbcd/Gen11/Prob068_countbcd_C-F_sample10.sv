module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    
    // Independent overflow detection
    wire ones_max = (ones == 4'd9);
    wire tens_max = (tens == 4'd9);
    wire hundreds_max = (hundreds == 4'd9);
    
    // Parallel enable generation
    assign ena[0] = ones_max;
    assign ena[1] = ones_max & tens_max;
    assign ena[2] = ones_max & tens_max & hundreds_max;
    
    // Parallel next value computation
    wire [3:0] next_ones = reset ? 4'd0 : (ones + 1'b1) % 4'd10;
    wire [3:0] next_tens = reset ? 4'd0 : 
                          ena[0] ? (tens + 1'b1) % 4'd10 : tens;
    wire [3:0] next_hundreds = reset ? 4'd0 : 
                              ena[1] ? (hundreds + 1'b1) % 4'd10 : hundreds;
    wire [3:0] next_thousands = reset ? 4'd0 : 
                               ena[2] ? (thousands + 1'b1) % 4'd10 : thousands;

    always @(posedge clk) begin
        ones <= next_ones;
        tens <= next_tens;
        hundreds <= next_hundreds;
        thousands <= next_thousands;
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule