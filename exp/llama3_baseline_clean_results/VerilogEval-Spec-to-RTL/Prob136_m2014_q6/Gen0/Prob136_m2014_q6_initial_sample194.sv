module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define the states
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101,
    // Add two more states for unused values
    IDLE = 3'b110,
    UNUSED = 3'b111
} currentState, nextState;

// Assign the output 'z' based on the current state
assign z = (currentState == E) || (currentState == F);

// Determine the next state based on the current state and the input 'w'
always_comb begin
    case (currentState)
        A: begin
            if (w)
                nextState = A;
            else
                nextState = B;
        end
        B: begin
            if (w)
                nextState = D;
            else
                nextState = C;
        end
        C: begin
            if (w)
                nextState = D;
            else
                nextState = E;
        end
        D: begin
            if (w)
                nextState = A;
            else
                nextState = F;
        end
        E: begin
            if (w)
                nextState = D;
            else
                nextState = E;
        end
        F: begin
            if (w)
                nextState = D;
            else
                nextState = C;
        end
        default: nextState = IDLE;
    endcase
end

// Update the current state on the positive edge of the clock
always_ff @(posedge clk) begin
    if (reset)
        currentState <= A;
    else
        currentState <= nextState;
end

endmodule