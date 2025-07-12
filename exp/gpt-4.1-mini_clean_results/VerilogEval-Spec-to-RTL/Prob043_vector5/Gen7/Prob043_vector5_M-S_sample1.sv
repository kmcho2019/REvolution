module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};
    integer i, j;

    // Function to generate 25-bit output vector for pairwise equality (XNOR)
    function [24:0] pairwise_xnor;
        input [4:0] vals;
        integer x, y;
        reg [24:0] result;
        begin
            for (x = 0; x < 5; x = x + 1) begin
                for (y = 0; y < 5; y = y + 1) begin
                    // The position in output vector counts from 24 down to 0 in row-major order
                    result[24 - (x * 5 + y)] = ~(vals[x] ^ vals[y]);
                end
            end
            pairwise_xnor = result;
        end
    endfunction

    assign out = pairwise_xnor(inputs);

endmodule