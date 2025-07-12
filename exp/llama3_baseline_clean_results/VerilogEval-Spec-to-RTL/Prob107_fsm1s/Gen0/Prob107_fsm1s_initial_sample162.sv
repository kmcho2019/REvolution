module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define parameters for the states
parameter S_B = 1'b0, S_A = 1'b1;

// Declare the current state variable
reg current_state;

// Determine the output based on the current state
always @(current_state)
begin
    case(current_state)
        S_B: out = 1'b1;
        S_A: out = 1'b0;
        default: out = 1'bx; // Handle unknown states
    endcase
end

// Determine the next state based on the current state and input
always @(posedge clk)
begin
    if(reset) // Synchronous reset
    begin
        current_state <= S_B;
    end
    else
    begin
        case(current_state)
            S_B:
            begin
                if(in == 1'b0)
                    current_state <= S_A;
                else
                    current_state <= S_B;
            end
            S_A:
            begin
                if(in == 1'b0)
                    current_state <= S_B;
                else
                    current_state <= S_A;
            end
            default: current_state <= S_B; // Default to state B on unknown states
        endcase
    end
end

// Initialize the current state to S_B (this is not strictly necessary but can help with simulation)
initial
begin
    current_state = S_B;
end

endmodule