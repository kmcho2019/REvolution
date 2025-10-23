module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);
    wire [3:0] p; // propagate signals: when no borrow needed at bit i
    wire [3:0] g; // generate signals: when borrow is generated at bit i
    wire [4:0] borrow; // borrow chain signals

    // Initialize borrow_in as 0 (no borrow going into LSB)
    assign borrow[0] = 1'b0;

    // For subtraction borrow calculation, at each bit:
    // borrow_out[i+1] = (~A[i] & B[i]) | ((~A[i] ^ B[i]) & borrow[i])
    assign g = (~A) & B;           // generate borrow at bit i
    assign p = (~A) ^ B;           // propagate borrow at bit i

    // Parallel prefix calculation of borrow signals to reduce ripple delay:
    // borrow[1] = g[0] | (p[0] & borrow[0])
    // borrow[2] = g[1] | (p[1] & borrow[1]) = g[1] | (p[1] & (g[0] | (p[0] & borrow[0])))
    // Similarly for borrow[3], borrow[4].
    assign borrow[1] = g[0] | (p[0] & borrow[0]);
    assign borrow[2] = g[1] | (p[1] & borrow[1]);
    assign borrow[3] = g[2] | (p[2] & borrow[2]);
    assign borrow[4] = g[3] | (p[3] & borrow[3]);

    // Equality check using bitwise XNOR and AND reduction
    wire eq_bits;
    assign eq_bits = &(~(A ^ B));

    // Output signals assignment
    // borrow[4] is the final borrow out indicating A < B
    assign A_less    = borrow[4];
    assign A_equal   = (~borrow[4]) & eq_bits;
    assign A_greater = (~borrow[4]) & (~eq_bits);

endmodule