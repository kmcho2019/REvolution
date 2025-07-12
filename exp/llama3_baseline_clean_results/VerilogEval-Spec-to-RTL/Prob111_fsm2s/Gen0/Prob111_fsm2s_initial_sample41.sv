module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // Current state: 0 - OFF, 1 - ON
reg [0:0] next_state; // Next state

// Output logic
assign out = state;

// Next state logic
always @(*) begin
    case(state)
        0: next_state = (j == 1)? 1 : 0; // If in OFF state and j=1, go to ON state, else stay in OFF
        1: next_state = (k == 1)? 0 : 1; // If in ON state and k=1, go to OFF state, else stay in ON
        default: next_state = 0; // Default to OFF state
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if(reset) begin // Active-high reset to OFF state
        state <= 0;
    end else begin
        state <= next_state;
    end
end

endmodule