module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // 1-bit signal to represent the state
reg [0:0] next_state; // 1-bit signal to represent the next state

// Determine the output 'out' based on the current state
assign out = state;

// Handle state transitions
always @ (posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        case (state)
            1'b0: begin // OFF state
                if (j) begin
                    state <= 1'b1; // Transition to ON state if j is 1
                end else begin
                    state <= 1'b0; // Stay in OFF state if j is 0
                end
            end
            1'b1: begin // ON state
                if (k) begin
                    state <= 1'b0; // Transition to OFF state if k is 1
                end else begin
                    state <= 1'b1; // Stay in ON state if k is 0
                end
            end
        endcase
    end
end

endmodule