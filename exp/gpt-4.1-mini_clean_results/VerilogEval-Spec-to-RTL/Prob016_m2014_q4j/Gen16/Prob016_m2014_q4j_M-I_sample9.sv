module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] p; // propagate
    wire [3:0] g; // generate
    wire [4:0] c; // carry signals, c[0] = 0 (initial carry in)

    assign c[0] = 1'b0;

    // propagate and generate for each bit
    assign p = x ^ y; // propagate = x XOR y
    assign g = x & y; // generate = x AND y

    // carry look-ahead logic
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) 
                  | (p[3] & p[2] & p[1] & p[0] & c[0]);

    // sum bits = propagate XOR carry-in
    assign sum = {c[4], p ^ c[3:0]};
endmodule