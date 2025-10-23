module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define states
enum {B, A} state, next_state;

// Output logic
always_comb begin
    case(state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'bx; // Default value
    endcase
end

// Next state logic and sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        case(state)
            B: if (!in) state <= A; else state <= B;
            A: if (!in) state <= B; else state <= A;
            default: state <= B; // Default next state
        endcase
    end
end

endmodule