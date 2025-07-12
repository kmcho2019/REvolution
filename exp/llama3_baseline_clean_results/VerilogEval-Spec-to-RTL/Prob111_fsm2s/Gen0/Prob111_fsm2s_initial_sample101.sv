module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg [0:0] state; // State variable, 0 for OFF, 1 for ON

always @ (posedge clk) begin
    if (reset) begin // Synchronous reset
        state <= 0; // Reset to OFF state
    end else begin
        case (state)
            0: begin // Current state is OFF
                if (j) begin
                    state <= 1; // Transition to ON if j=1
                end else begin
                    state <= 0; // Stay in OFF if j=0
                end
            end
            1: begin // Current state is ON
                if (k) begin
                    state <= 0; // Transition to OFF if k=1
                end else begin
                    state <= 1; // Stay in ON if k=0
                end
            end
        endcase
    end
end

always @ (*) begin
    case (state)
        0: out = 0; // Output is 0 in OFF state
        1: out = 1; // Output is 1 in ON state
    endcase
end

endmodule