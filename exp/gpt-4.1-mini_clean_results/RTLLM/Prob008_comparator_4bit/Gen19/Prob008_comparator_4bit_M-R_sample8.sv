module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] eq; // per-bit equality signals
    wire [3:0] g;  // borrow generate signals
    wire [3:0] p;  // borrow propagate signals

    // Compute per-bit equality, borrow generate, and propagate signals
    assign eq = ~(A ^ B);          // bitwise XNOR
    assign g  = (~A) & B;          // borrow generate: A[i] < B[i]
    assign p  = eq;                // borrow propagate: borrow propagates if bits equal

    // Calculate borrow chain explicitly from LSB to MSB
    reg borrow;
    integer i;
    reg [3:0] borrow_chain;

    always @(*) begin
        borrow_chain[0] = g[0];
        for (i = 1; i < 4; i = i + 1) begin
            borrow_chain[i] = g[i] | (p[i] & borrow_chain[i-1]);
        end
        borrow = borrow_chain[3];
    end

    // Determine equality: all bits equal means all eq bits are 1
    wire equal_bits = &eq;

    // Outputs mutually exclusive
    assign A_less    = borrow;
    assign A_equal   = equal_bits;
    assign A_greater = ~borrow & ~equal_bits;

endmodule