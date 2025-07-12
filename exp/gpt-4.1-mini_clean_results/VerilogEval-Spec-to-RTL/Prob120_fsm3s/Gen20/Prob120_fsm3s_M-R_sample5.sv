module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding (2-bit binary)
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    reg [1:0] state;
    wire [1:0] next_state;

    // Next state logic as combinational expressions derived from the FSM table
    // next_state[1]:
    // State encoding: A=00, B=01, C=10, D=11
    // Next states from table:
    // For next_state[1] (MSB):
    // A: in=0->A(00), in=1->B(01) => next_state[1]=0
    // B: in=0->C(10), in=1->B(01) => next_state[1]= in & ~state[0] (since B=01)
    // C: in=0->A(00), in=1->D(11) => next_state[1]= in
    // D: in=0->C(10), in=1->B(01) => next_state[1]= ~in
    //
    // To simplify, implement via mux logic:
    // next_state[1] = (state == B && in == 0) || (state == C && in == 1) || (state == D && in == 0)
    // Represent states as bits for logic:
    wire state_is_A = (state == A);
    wire state_is_B = (state == B);
    wire state_is_C = (state == C);
    wire state_is_D = (state == D);

    assign next_state[1] = (state_is_B & ~in) | (state_is_C & in) | (state_is_D & ~in);

    // next_state[0]:
    // From table:
    // A: in=0->A(00), in=1->B(01) => next_state[0]= in
    // B: in=0->C(10), in=1->B(01) => next_state[0]= ~in | in (always 1 for in=1?), actually B->C or B -> B, C=10 next_state[0]=0, B=01 next_state[0]=1
    // So when in=0, next_state=10 (C) => next_state[0]=0; when in=1 next_state=01 (B) => next_state[0]=1
    // So for B: next_state[0] = in
    // C: in=0->A(00), in=1->D(11) => next_state[0]= in
    // D: in=0->C(10), in=1->B(01) => next_state[0]= ~in

    assign next_state[0] = (state_is_A & in)
                        | (state_is_B & in)
                        | (state_is_C & in)
                        | (state_is_D & ~in);

    // State update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore output: output is 1 only in state D
    assign out = state_is_D;

endmodule