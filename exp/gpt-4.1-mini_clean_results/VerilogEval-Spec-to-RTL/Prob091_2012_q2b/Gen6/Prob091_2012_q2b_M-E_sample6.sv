module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // We'll use temporary wires to accumulate contributions for Y1 and Y3
    wire [5:0] y_bits = y;
    wire w_n = ~w;

    // Declare registers to accumulate terms inside always_comb block
    reg y1_next;
    reg y3_next;

    integer i;

    always @(*) begin
        // Initialize accumulators
        y1_next = 1'b0;
        y3_next = 1'b0;

        // Loop over all states for Y1 (target state B -> y[1])
        // According to FSM: Y1 = y[0]&w
        // We'll implement this by checking each y[i], conditions for transitions to B
        // Only state A (y[0]) transitions to B when w=1
        for (i = 0; i < 6; i = i + 1) begin
            case (i)
                0: y1_next = y1_next | (y_bits[i] & w);   // A->B on w=1
                default: ; // no other transitions to B
            endcase
        end

        // Loop over all states for Y3 (target state D -> y[3])
        // Transitions to D:
        // B(1) on w=0, C(2) on w=0, E(4) on w=0, F(5) on w=0
        for (i = 0; i < 6; i = i + 1) begin
            case(i)
                1,2,4,5: y3_next = y3_next | (y_bits[i] & w_n);
                default: ; // no other transitions to D
            endcase
        end
    end

    assign Y1 = y1_next;
    assign Y3 = y3_next;

endmodule