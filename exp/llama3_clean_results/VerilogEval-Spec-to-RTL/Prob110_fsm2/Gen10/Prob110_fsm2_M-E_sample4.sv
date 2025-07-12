module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg [0:0] current_state; // current state
reg [0:0] next_state;    // next state

// Define the states as parameters
parameter OFF = 1'b0;
parameter ON  = 1'b1;

// Combinational logic for next state and output
always @(*) begin
    case (current_state)
        OFF: begin
            next_state = j? ON : OFF;
        end
        ON: begin
            next_state = k? OFF : ON;
        end
        default: next_state = OFF;
    endcase
end

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

// Output logic directly from state
assign out = (current_state == ON)? 1'b1 : 1'b0;

endmodule