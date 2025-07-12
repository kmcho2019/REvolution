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
        if (WIDTH == 2) begin
            // Base case: swap two bits
            assign out = {in[0], in[1]};
        end
        else begin
            // Recursive case: split into halves and concatenate reversed
            wire [WIDTH/2-1:0] first_half, second_half;
            wire [WIDTH/2-1:0] rev_first, rev_second;
            
            assign first_half = in[WIDTH-1:WIDTH/2];
            assign second_half = in[WIDTH/2-1:0];
            
            ReverseBits #(WIDTH/2) rev1(first_half, rev_first);
            ReverseBits #(WIDTH/2) rev2(second_half, rev_second);
            
            assign out = {rev_second, rev_first};
        end
    endgenerate
endmodule

// Instantiate the recursive module
ReverseBits rev(.in(in), .out(out));

endmodule