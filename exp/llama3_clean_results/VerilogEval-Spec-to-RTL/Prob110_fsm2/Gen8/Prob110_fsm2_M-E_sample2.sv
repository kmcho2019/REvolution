module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

// One-hot encoding for states
reg [1:0] current_state; // current state (one-hot)
reg [1:0] next_state;    // next state (one-hot)

// Initialize states
parameter OFF = 2'b01; // OFF state
parameter ON  = 2'b10; // ON state

// Next state logic
always @(*) begin
    case (current_state)
        OFF: next_state = (j) ? ON : OFF;
        ON:  next_state = (k) ? OFF : ON;
        default: next_state = OFF;
    endcase
end

// State register update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

// Output logic directly from state
assign out = current_state[1]; // output is '1' when in ON state

endmodule