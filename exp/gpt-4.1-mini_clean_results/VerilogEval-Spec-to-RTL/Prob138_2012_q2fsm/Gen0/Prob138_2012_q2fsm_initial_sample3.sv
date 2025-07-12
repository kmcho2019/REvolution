module TopModule (
    input clk,
    input reset,
    input w,
    output z
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

    state_t current_state, next_state;

    // State flip-flops (sequential block)
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next state logic (combinational block)
    always @(*) begin
        case (current_state)
            A: next_state = (w == 1'b1) ? B : A;
            B: next_state = (w == 1'b1) ? C : D;
            C: next_state = (w == 1'b1) ? E : D;
            D: next_state = (w == 1'b1) ? F : A;
            E: next_state = (w == 1'b1) ? E : D;
            F: next_state = (w == 1'b1) ? C : D;
            default: next_state = A; // safe default
        endcase
    end

    // Output logic: z = 1 only in state E
    assign z = (current_state == E) ? 1'b1 : 1'b0;

endmodule