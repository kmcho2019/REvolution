module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1, // next-state bit for B (y[1])
    output       Y3  // next-state bit for D (y[3])
);

    // One-hot encoding of states:
    // y[0] = A(0), y[1] = B(1), y[2] = C(2), y[3] = D(3), y[4] = E(4), y[5] = F(5)

    // Decode current state index from one-hot y
    reg [2:0] state;
    integer i;
    always @(*) begin
        state = 3'd0;
        for (i = 0; i < 6; i = i + 1)
            if (y[i]) state = i[2:0];
    end

    // Compute next state index according to the state machine and input w
    reg [2:0] next_state;
    always @(*) begin
        case (state)
            3'd0: next_state = (w == 1'b0) ? 3'd1 : 3'd0;       // A: 0->B(1) if w=0 else A(0)
            3'd1: next_state = (w == 1'b0) ? 3'd2 : 3'd3;       // B: 0->C(2), 1->D(3)
            3'd2: next_state = (w == 1'b0) ? 3'd4 : 3'd3;       // C: 0->E(4), 1->D(3)
            3'd3: next_state = (w == 1'b0) ? 3'd5 : 3'd0;       // D: 0->F(5), 1->A(0)
            3'd4: next_state = (w == 1'b0) ? 3'd4 : 3'd3;       // E: 0->E(4), 1->D(3)
            3'd5: next_state = (w == 1'b0) ? 3'd2 : 3'd3;       // F: 0->C(2), 1->D(3)
            default: next_state = 3'd0;
        endcase
    end

    // Output next-state bits Y1 = y[1] of next state, Y3 = y[3] of next state
    assign Y1 = (next_state == 3'd1);
    assign Y3 = (next_state == 3'd3);

endmodule