module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [1:0] state; // Two states: 0 - OFF, 1 - ON
reg [1:0] nextState;

// Asynchronous reset to state OFF
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // OFF state
    end else begin
        state <= nextState;
    end
end

// Determine next state based on current state and inputs
always @(*) begin
    case(state)
        0: // OFF state
            if (j) begin
                nextState = 1; // Move to ON state if j is high
            end else begin
                nextState = 0; // Stay in OFF state if j is low
            end
        1: // ON state
            if (k) begin
                nextState = 0; // Move to OFF state if k is high
            end else begin
                nextState = 1; // Stay in ON state if k is low
            end
        default:
            nextState = 0; // Default to OFF state if unknown
    endcase
end

// Output determined by current state
assign out = state[0]; // out is 1 in ON state and 0 in OFF state

endmodule