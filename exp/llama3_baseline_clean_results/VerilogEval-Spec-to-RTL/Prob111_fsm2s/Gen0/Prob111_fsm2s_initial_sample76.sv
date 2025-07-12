module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // Using a single bit for two states: OFF (0) and ON (1)
reg [0:0] nextState;

// Output logic
assign out = state;

// State transition logic
always @(posedge clk or posedge reset) begin
    if(reset) begin // Synchronous reset
        state <= 0; // Reset to OFF state
    end else begin
        case(state)
            0: // OFF state
                if(j) begin
                    state <= 1; // Transition to ON if j = 1
                end else begin
                    state <= 0; // Stay in OFF if j = 0
                end
            1: // ON state
                if(k) begin
                    state <= 0; // Transition to OFF if k = 1
                end else begin
                    state <= 1; // Stay in ON if k = 0
                end
            default: state <= 0; // Default to OFF for any other state (should not occur)
        endcase
    end
end

endmodule