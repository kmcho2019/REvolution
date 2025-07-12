module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Enum for states
enum logic [0:0] {B, A} state, next_state;

// Output assignment based on the state
always_comb begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'bx; // Default case, should not occur
    endcase
end

// State transition logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= B; // Reset to state B
    end else begin
        case (state)
            B: if (in == 1'b0) state <= A; else state <= B;
            A: if (in == 1'b0) state <= B; else state <= A;
            default: state <= B; // Default case, should not occur
        endcase
    end
end

endmodule