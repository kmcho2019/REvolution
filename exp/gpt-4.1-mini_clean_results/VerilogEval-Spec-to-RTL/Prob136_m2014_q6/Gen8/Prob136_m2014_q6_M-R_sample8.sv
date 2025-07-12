module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding
    typedef enum logic [2:0] {
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5
    } state_t;

    state_t state, next_state;

    // Next state logic using continuous assignments and mux-style expressions
    wire [2:0] next_state_wire;
    assign next_state_wire =
        (state == A) ? (w ? A : B) :
        (state == B) ? (w ? D : C) :
        (state == C) ? (w ? D : E) :
        (state == D) ? (w ? A : F) :
        (state == E) ? (w ? D : E) :
        (state == F) ? (w ? D : C) :
        A;

    // Sequential logic: state update on positive clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state_wire;
    end

    // Registered output logic: output z depends on current state
    always @(posedge clk) begin
        if (reset)
            z <= 1'b0;
        else
            z <= (state == E) || (state == F);
    end

endmodule