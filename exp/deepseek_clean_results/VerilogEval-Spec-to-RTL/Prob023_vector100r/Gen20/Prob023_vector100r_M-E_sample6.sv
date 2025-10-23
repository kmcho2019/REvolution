module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// Base case module for 8-bit reversal
module Reverse8 (
    input  [7:0] in,
    output [7:0] out
);
    assign out = {in[0], in[1], in[2], in[3], 
                 in[4], in[5], in[6], in[7]};
endmodule

// Parameterized recursive reversal module
module RecursiveReverse #(parameter WIDTH = 100) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    generate
        if (WIDTH <= 8) begin
            // Base case: use the 8-bit reverser (pad if needed)
            wire [7:0] padded_in = WIDTH < 8 ? {in, {8-WIDTH{1'b0}}} : in;
            wire [7:0] reversed;
            Reverse8 rev8(.in(padded_in), .out(reversed));
            assign out = reversed[WIDTH-1:0];
        end
        else begin
            // Recursive case: split into halves and process
            localparam HALF = WIDTH / 2;
            localparam REMAINDER = WIDTH % 2;
            
            wire [HALF+REMAINDER-1:0] upper_reversed;
            wire [HALF-1:0] lower_reversed;
            
            RecursiveReverse #(HALF+REMAINDER) rev_upper(
                .in(in[WIDTH-1:HALF]),
                .out(upper_reversed)
            );
            
            RecursiveReverse #(HALF) rev_lower(
                .in(in[HALF-1:0]),
                .out(lower_reversed)
            );
            
            assign out = {lower_reversed, upper_reversed};
        end
    endgenerate
endmodule

// Instantiate the recursive reverser
RecursiveReverse #(100) rev100 (
    .in(in),
    .out(out)
);

endmodule