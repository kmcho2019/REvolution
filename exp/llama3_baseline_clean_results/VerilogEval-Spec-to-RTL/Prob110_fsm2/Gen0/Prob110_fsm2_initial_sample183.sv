module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define the states
parameter OFF = 1'b0;
parameter ON  = 1'b1;

reg [0:0] state;  // Current state
reg [0:0] next_state;  // Next state

// Combinational logic for next state and output
always @(*) begin
    case (state)
        OFF: begin
            if (j == 1'b1) next_state = ON;
            else next_state = OFF;
        end
        ON: begin
            if (k == 1'b1) next_state = OFF;
            else next_state = ON;
        end
        default: next_state = OFF;
    endcase
    
    // Output is determined by the current state
    if (state == ON) out = 1'b1;
    else out = 1'b0;
end

// Sequential logic for state register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) state <= OFF;
    else state <= next_state;
end

endmodule