module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // Current state (0 - OFF, 1 - ON)
reg [0:0] next_state; // Next state

// Combinational logic to determine next state
always @(*) begin
    case (state)
        0: begin // OFF state
            if (j == 1) next_state = 1;
            else next_state = 0;
        end
        1: begin // ON state
            if (k == 1) next_state = 0;
            else next_state = 1;
        end
        default: next_state = 0; // Default to OFF state
    endcase
end

// Sequential logic to update current state
always @(posedge clk or posedge areset) begin
    if (areset) state <= 0; // Asynchronous reset to OFF state
    else state <= next_state;
end

// Output logic
assign out = state; // Output is 1 when in ON state, 0 when in OFF state

endmodule