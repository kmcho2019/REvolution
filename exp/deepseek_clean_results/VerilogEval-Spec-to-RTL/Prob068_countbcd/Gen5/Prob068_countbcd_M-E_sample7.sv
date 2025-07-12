module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    wire ones_overflow = (ones == 4'd9);
    wire tens_overflow = (tens == 4'd9);
    wire hundreds_overflow = (hundreds == 4'd9);
    
    // Enable signals (parallel computation)
    assign ena[0] = ones_overflow;
    assign ena[1] = ones_overflow & tens_overflow;
    assign ena[2] = ones_overflow & tens_overflow & hundreds_overflow;
    
    // Next digit values (computed in parallel)
    wire [3:0] next_ones = reset ? 4'd0 : (ones + 1'b1) & {4{~ones_overflow}};
    wire [3:0] next_tens = reset ? 4'd0 : 
                          (tens + {3'b0, ena[0]}) & {4{~(ena[0] & tens_overflow)}};
    wire [3:0] next_hundreds = reset ? 4'd0 : 
                              (hundreds + {3'b0, ena[1]}) & {4{~(ena[1] & hundreds_overflow)}};
    wire [3:0] next_thousands = reset ? 4'd0 : 
                               (thousands + {3'b0, ena[2]}) & {4{~(ena[2] & (thousands == 4'd9))}};

    always @(posedge clk) begin
        ones <= next_ones;
        tens <= next_tens;
        hundreds <= next_hundreds;
        thousands <= next_thousands;
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule