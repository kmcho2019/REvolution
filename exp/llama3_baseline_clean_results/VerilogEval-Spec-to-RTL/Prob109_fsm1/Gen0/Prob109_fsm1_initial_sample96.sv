module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Enum for states
enum logic [0:0] {A, B} state, next_state;

// Output logic
assign out = state;

// Next state logic
always_comb begin
    case(state)
        A: begin
            if(in == 0) next_state = B;
            else next_state = A;
        end
        B: begin
            if(in == 0) next_state = A;
            else next_state = B;
        end
        default: next_state = B; // Default state
    endcase
end

// State register
always_ff @(posedge clk or posedge areset) begin
    if(areset) state <= B; // Asynchronous reset
    else state <= next_state;
end

endmodule