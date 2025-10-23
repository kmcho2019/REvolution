module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // One-hot state encoding: 4 flip-flops, each representing a state
    reg A_state, B_state, C_state, D_state;

    // Next state signals
    wire A_next, B_next, C_next, D_next;

    // Next state logic according to the transition table:
    // From A: in=0->A, in=1->B
    assign A_next = (A_state && (in == 1'b0)) || (C_state && (in == 1'b0));
    assign B_next = (A_state && (in == 1'b1)) || (B_state && (in == 1'b1)) || (D_state && (in == 1'b1));
    assign C_next = (B_state && (in == 1'b0)) || (D_state && (in == 1'b0));
    assign D_next = (C_state && (in == 1'b1));

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            // Reset to state A only
            A_state <= 1'b1;
            B_state <= 1'b0;
            C_state <= 1'b0;
            D_state <= 1'b0;
        end else begin
            A_state <= A_next;
            B_state <= B_next;
            C_state <= C_next;
            D_state <= D_next;
        end
    end

    // Moore output depends only on current state D
    always @(*) begin
        out = D_state;
    end

endmodule