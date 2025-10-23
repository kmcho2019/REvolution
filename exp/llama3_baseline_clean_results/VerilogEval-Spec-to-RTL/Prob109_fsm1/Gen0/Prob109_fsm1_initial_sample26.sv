module TopModule(
    input         clk,
    input         areset,
    input         in,
    output reg    out
);

// Define the states
enum logic [1:0] {
    A,
    B
} state, next_state;

// Initialize the output based on the state
always_comb begin
    case(state)
        A: out = 0;
        B: out = 1;
        default: out = 1'b0;
    endcase
end

// State transition logic
always @(*) begin
    case(state)
        A: begin
            if (in == 0) next_state = B;
            else next_state = A;
        end
        B: begin
            if (in == 0) next_state = A;
            else next_state = B;
        end
        default: next_state = B;
    endcase
end

// Update the current state
always @(posedge clk or posedge areset) begin
    if (areset) state <= B;
    else state <= next_state;
end

endmodule