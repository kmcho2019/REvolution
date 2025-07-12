module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Define the states of the FSM
typedef enum logic [2:0] {
    StateA, // Reset state
    SetF,   // State to set f to 1
    WaitX1, // First state to monitor x
    WaitX2, // Second state to monitor x
    WaitX3, // Third state to monitor x
    SetG,   // State to set g to 1
    CheckY1, // First cycle to check y
    CheckY2  // Second cycle to check y
} State;

// Current state register
State current_state;

// Initialize the current state
initial current_state = StateA;

// Assign outputs
assign f = (current_state == SetF);
assign g = (current_state >= SetG);

always @(posedge clk) begin
    if (!resetn) begin
        // If reset is asserted, go back to state A
        current_state <= StateA;
    end else begin
        case (current_state)
            StateA: current_state <= SetF; // Move to set f state after reset de-assertion
            SetF: begin
                if (x == 1) current_state <= WaitX1;
                else current_state <= SetF; // Stay here until x is 1
            end
            WaitX1: begin
                if (x == 0) current_state <= WaitX2;
                else current_state <= WaitX1; // Stay here until x is 0
            end
            WaitX2: begin
                if (x == 1) current_state <= WaitX3;
                else current_state <= WaitX1; // Reset x sequence if it fails
            end
            WaitX3: begin
                current_state <= SetG;
            end
            SetG: current_state <= CheckY1;
            CheckY1: begin
                if (y == 1) current_state <= SetG; // If y is 1, stay in SetG state
                else current_state <= CheckY2;
            end
            CheckY2: begin
                if (y == 1) current_state <= SetG; // If y is 1, stay in SetG state
                else current_state <= StateA; // If y is not 1 in two cycles, reset FSM
            end
            default: current_state <= StateA; // Default to state A for any other condition
        endcase
    end
end

endmodule