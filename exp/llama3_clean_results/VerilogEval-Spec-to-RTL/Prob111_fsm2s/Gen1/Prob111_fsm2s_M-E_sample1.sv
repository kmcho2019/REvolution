module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

// Define the states
localparam OFF = 1'b0;
localparam ON  = 1'b1;

// Declare the current state variable
reg current_state;

// Sequential logic: update current state on clock edge
always @(posedge clk)
begin
    if (reset)
        current_state <= OFF; // Synchronous reset
    else
    begin
        case ({current_state, j, k})
            {OFF, 1'b1, _}: current_state <= ON;
            {ON, _, 1'b1}: current_state <= OFF;
            default: current_state <= current_state;
        endcase
    end
end

// Moore state machine: output is a function of the current state
always @(current_state)
begin
    case (current_state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'bx; // Handle undefined states
    endcase
end

endmodule