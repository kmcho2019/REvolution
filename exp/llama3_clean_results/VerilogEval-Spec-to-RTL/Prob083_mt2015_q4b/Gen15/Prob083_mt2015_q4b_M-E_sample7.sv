module TopModule(
    input x,
    input y,
    output z
);

// Define the states of the FSM
enum logic [1:0] {S0, S1, S2, S3} state, next_state;

// Initialize the state
initial state = S0;

// State transition logic
always @(posedge x or posedge y or negedge x or negedge y) begin
    case(state)
        S0: if (~x && ~y) next_state = S0;
             else if (x && ~y) next_state = S1;
             else if (~x && y) next_state = S2;
             else if (x && y) next_state = S3;
        S1: if (~x && ~y) next_state = S0;
             else if (x && ~y) next_state = S1;
             else if (~x && y) next_state = S2;
             else if (x && y) next_state = S3;
        S2: if (~x && ~y) next_state = S0;
             else if (x && ~y) next_state = S1;
             else if (~x && y) next_state = S2;
             else if (x && y) next_state = S3;
        S3: if (~x && ~y) next_state = S0;
             else if (x && ~y) next_state = S1;
             else if (~x && y) next_state = S2;
             else if (x && y) next_state = S3;
        default: next_state = S0;
    endcase
end

// Update the current state
always @(posedge x or posedge y or negedge x or negedge y) begin
    state = next_state;
end

// Output logic
assign z = (state == S0 || state == S3) ? 1'b1 : 1'b0;

endmodule