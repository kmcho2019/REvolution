module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [1:0] state; // Two states: OFF (0) and ON (1)
reg [1:0] nextState;

// Output logic: out is 1 when state is ON (1)
assign out = (state == 1) ? 1'b1 : 1'b0;

// Asynchronous reset to OFF state
always @(posedge clk or posedge areset)
begin
    if (areset) begin
        state <= 0; // Reset to OFF state
    end else begin
        state <= nextState;
    end
end

// Next state logic based on current state and inputs j and k
always @(*)
begin
    case (state)
        0: // Current state is OFF
            begin
                if (j == 1'b1) begin
                    nextState = 1; // Transition to ON if j is high
                end else begin
                    nextState = 0; // Stay in OFF if j is low
                end
            end
        1: // Current state is ON
            begin
                if (k == 1'b1) begin
                    nextState = 0; // Transition to OFF if k is high
                end else begin
                    nextState = 1; // Stay in ON if k is low
                end
            end
        default:
            begin
                nextState = 0; // Invalid state, default to OFF
            end
    endcase
end

endmodule