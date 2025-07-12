module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // Current state, 0 for OFF, 1 for ON

always @(posedge clk) begin
    if (reset) begin // Active-high synchronous reset
        state <= 0; // Reset to OFF state
    end else begin
        case (state)
            0: begin // OFF state
                if (j) begin
                    state <= 1; // Transition to ON state if j=1
                end else begin
                    state <= 0; // Stay in OFF state if j=0
                end
            end
            1: begin // ON state
                if (k) begin
                    state <= 0; // Transition to OFF state if k=1
                end else begin
                    state <= 1; // Stay in ON state if k=0
                end
            end
        endcase
    end
end

assign out = state; // Output is the current state (0 for OFF, 1 for ON)

endmodule