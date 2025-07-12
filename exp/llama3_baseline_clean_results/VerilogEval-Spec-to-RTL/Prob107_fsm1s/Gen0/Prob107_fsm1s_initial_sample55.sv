module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Enumerate the states for clarity
enum logic [0:0] {B, A} state, next_state;

// Output logic: out is 1 in state B, 0 in state A
always_comb begin
    case(state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'bx; // Default to unknown for invalid states
    endcase
end

// State transition logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= B; // Reset to state B on reset
    end else begin
        case(state)
            B: begin
                if (!in) begin
                    state <= A; // Transition from B to A on in=0
                end else begin
                    state <= B; // Stay in B on in=1
                end
            end
            A: begin
                if (!in) begin
                    state <= B; // Transition from A to B on in=0
                end else begin
                    state <= A; // Stay in A on in=1
                end
            end
            default: state <= B; // Default to state B for invalid states
        endcase
    end
end

endmodule