module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [0:0] state; // State variable
reg [0:0] next_state; // Next state variable

// Initialize state to B (1) at power-up
initial state = 1'b1;

// Output out is determined solely by the current state
always @(*) 
begin
    case(state)
        1'b0: out = 1'b0; // State A
        1'b1: out = 1'b1; // State B
        default: out = 1'b0; // Default output (optional)
    endcase
end

// State machine's next state logic
always @(*) 
begin
    if(reset) 
        next_state = 1'b1; // Reset to state B
    else 
    begin
        case(state)
            1'b0: // State A
                begin
                    if(!in) next_state = 1'b1; // in=0 -> State B
                    else next_state = 1'b0; // in=1 -> State A
                end
            1'b1: // State B
                begin
                    if(!in) next_state = 1'b1; // in=0 -> State B
                    else next_state = 1'b1; // in=1 -> State B
                end
            default: next_state = 1'b1; // Default next state (optional)
        endcase
    end
end

// Synchronous update of state
always @(posedge clk) 
    state <= next_state;

endmodule