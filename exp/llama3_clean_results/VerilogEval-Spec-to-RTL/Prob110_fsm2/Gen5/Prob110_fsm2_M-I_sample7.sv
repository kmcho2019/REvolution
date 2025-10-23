module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define states
parameter OFF = 1'b0;
parameter ON  = 1'b1;

// Current state register
reg current_state;

// Initialize output
assign out = current_state;

// State machine logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        case (current_state)
            OFF: current_state <= j ? ON : OFF;
            ON:  current_state <= k ? OFF : ON;
            default: current_state <= OFF;
        endcase
    end
end

endmodule