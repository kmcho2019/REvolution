module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // Define the four states using an enumerated type
    typedef enum logic [1:0] {
        A = 2'd0,
        B = 2'd1,
        C = 2'd2,
        D = 2'd3
    } state_t;

    state_t state, next_state;

    // Sequential always block: state transitions and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            state <= next_state;
            // Moore output depends only on current state (before update)
            // So output is updated after state assignment with the previous state next_state
            // However, in this style output is from current state, so update output based on next_state after updating state
            // To preserve Moore behavior output is updated here based on next_state which will become current state next cycle
            // Instead, output should be based on state (the updated one), so we assign output after state updated.
            // But inside this clocked block, assignments take effect after block ends, so output uses new state
            // So simply assign output based on next_state after updating state.
            out <= (next_state == D) ? 1'b1 : 1'b0;
        end
    end

    // Combinational always block: next state logic
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A; // safety fallback
        endcase
    end

endmodule