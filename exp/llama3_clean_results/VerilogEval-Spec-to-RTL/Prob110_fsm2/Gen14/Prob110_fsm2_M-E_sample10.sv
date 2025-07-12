// Define the states as parameters for one-hot encoding
parameter OFF = 2'b01;
parameter ON  = 2'b10;

module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg [1:0] current_state; // current state using one-hot encoding

// State register update with simplified next-state logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        case (current_state)
            OFF: current_state <= j ? ON : OFF;
            ON:  current_state <= ~k ? ON : OFF;
        endcase
    end
end

// Output logic directly from state
assign out = current_state[1]; // ON state bit

endmodule