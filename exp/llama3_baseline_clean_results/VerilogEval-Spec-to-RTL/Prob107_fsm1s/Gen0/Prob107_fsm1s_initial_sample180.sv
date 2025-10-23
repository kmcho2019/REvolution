`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define an enum for the states
enum logic [0:0] {B, A} state, next_state;

// Output is determined by the current state
always_comb begin
    case(state)
        B: out = 1'b1;
        A: out = 1'b0;
    endcase
end

// State transitions
always_ff @(posedge clk) begin
    if (reset) begin
        // Reset to state B when reset is high
        state <= B;
    end else begin
        // Transition based on current state and input
        case(state)
            B: begin
                if (in) begin
                    state <= B;
                end else begin
                    state <= A;
                end
            end
            A: begin
                if (in) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
        endcase
    end
end

endmodule