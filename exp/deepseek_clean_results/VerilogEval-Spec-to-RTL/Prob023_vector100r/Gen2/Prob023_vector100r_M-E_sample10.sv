module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// Recursive bit reversal module
module ReverseBits #(parameter WIDTH = 100) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    generate
        if (WIDTH == 1) begin
            assign out = in;
        end
        else begin
            localparam HALF = WIDTH / 2;
            wire [HALF-1:0] first_half, second_half;
            wire [HALF-1:0] reversed_first, reversed_second;
            
            assign first_half = in[WIDTH-1:HALF];
            assign second_half = in[HALF-1:0];
            
            ReverseBits #(HALF) rev_first (.in(first_half), .out(reversed_first));
            ReverseBits #(HALF) rev_second (.in(second_half), .out(reversed_second));
            
            assign out = {reversed_second, reversed_first};
        end
    endgenerate
endmodule

// Instantiate the recursive module
ReverseBits #(100) rev (.in(in), .out(out));

endmodule