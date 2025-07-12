module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states as an enum
enum logic [0:0] {A, B} state, next_state;

// Initialize the state to B on reset
initial state = B;

// State machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= B; // Asynchronously reset to state B
    end else begin
        case (state)
            B: if (!in) state <= A; else state <= B;
            A: if (!in) state <= B; else state <= A;
            default: state <= B; // default to state B
        endcase
    end
end

// Output logic
assign out = (state == B) ? 1'b1 : 1'b0;

endmodule