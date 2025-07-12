module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] g; // borrow generate signals
    wire [3:0] p; // borrow propagate signals
    reg  [4:0] borrow; // borrow chain: borrow[0] = 0 initial borrow_in

    // Compute generate and propagate signals vectorized
    assign g = (~A) & B;       // borrow generate when A[i] < B[i]
    assign p = ~(A ^ B);       // borrow propagate when bits equal

    // Compute borrow chain in combinational always block
    always @(*) begin
        borrow[0] = 1'b0; // borrow in is zero for A - B
        // Generate borrow for each bit using ripple borrow logic
        integer i;
        for (i = 0; i < 4; i = i + 1) begin
            borrow[i+1] = g[i] | (p[i] & borrow[i]);
        end
    end

    // Equality check: all bits equal if propagate for all bits is 1
    wire equal_bits = &p;

    // Outputs
    assign A_less    = borrow[4];              // borrow out indicates A < B
    assign A_equal   = equal_bits;             // all bits equal
    assign A_greater = ~(borrow[4] | equal_bits); // else A > B

endmodule