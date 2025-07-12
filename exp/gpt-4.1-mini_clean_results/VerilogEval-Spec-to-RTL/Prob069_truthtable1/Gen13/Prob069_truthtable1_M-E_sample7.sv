module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);
    wire [2:0] addr;
    // Store truth table in a parameter (bit 0 = LSB for addr=0)
    // Index order: x3 x2 x1
    // Table from problem (f for addr 0 to 7):
    // addr | x3 x2 x1 | f
    // 0    | 0  0  0 | 0
    // 1    | 0  0  1 | 0
    // 2    | 0  1  0 | 1
    // 3    | 0  1  1 | 1
    // 4    | 1  0  0 | 0
    // 5    | 1  0  1 | 1
    // 6    | 1  1  0 | 0
    // 7    | 1  1  1 | 1
    localparam [7:0] truth_table = 8'b10010110;

    assign addr = {x3, x2, x1};
    assign f = truth_table[addr];

endmodule