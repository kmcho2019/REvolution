// Define the states as parameters
parameter OFF = 1'b0;
parameter ON  = 1'b1;

module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg current_state; // current state

// State register update logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        case (current_state)
            OFF: if (j) current_state <= ON; else current_state <= OFF;
            ON:  if (k) current_state <= OFF; else current_state <= ON;
            default: current_state <= OFF;
        endcase
    end
end

// Output logic directly from state
assign out = current_state;

endmodule