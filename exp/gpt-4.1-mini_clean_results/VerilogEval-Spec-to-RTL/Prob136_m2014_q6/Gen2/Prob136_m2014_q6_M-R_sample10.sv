module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z
);

    // Use typedef enum for clearer state definition
    typedef enum logic [2:0] {
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5
    } state_t;

    state_t state, next_state;

    // Next state and output logic combined, synchronous output register
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 1'b0;
        end else begin
            case(state)
                A: next_state = (w == 1'b0) ? B : A;
                B: next_state = (w == 1'b0) ? C : D;
                C: next_state = (w == 1'b0) ? E : D;
                D: next_state = (w == 1'b0) ? F : A;
                E: next_state = (w == 1'b0) ? E : D;
                F: next_state = (w == 1'b0) ? C : D;
                default: next_state = A;
            endcase
            state <= next_state;

            // Output z registered, 1 in states E and F, else 0
            z <= (next_state == E) || (next_state == F);
        end
    end

endmodule