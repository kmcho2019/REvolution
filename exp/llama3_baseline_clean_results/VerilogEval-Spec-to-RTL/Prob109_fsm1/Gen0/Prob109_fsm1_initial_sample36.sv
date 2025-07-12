module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define states
enum logic [0:0] {B, A} state, next_state;

// Asynchronous reset
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// State transitions
always_comb begin
    case (state)
        B: next_state = (in) ? B : A;
        A: next_state = (in) ? A : B;
        default: next_state = B; // Default state
    endcase
end

// Output logic
assign out = (state == B) ? 1'b1 : 1'b0;

endmodule