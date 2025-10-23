module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

reg [0:0] state;  // Current state (0 - OFF, 1 - ON)
reg [0:0] next_state;  // Next state

always @(*) begin
    case (state)
        0: begin  // State OFF
            if (j == 1'b1) begin
                next_state = 1'b1;  // Transition to ON if j is 1
            end else begin
                next_state = 1'b0;  // Stay in OFF if j is 0
            end
        end
        1: begin  // State ON
            if (k == 1'b1) begin
                next_state = 1'b0;  // Transition to OFF if k is 1
            end else begin
                next_state = 1'b1;  // Stay in ON if k is 0
            end
        end
        default: begin
            next_state = 1'b0;  // Default to OFF if state is unknown
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0;  // Synchronous reset to OFF state
    end else begin
        state <= next_state;  // Update state on every positive clock edge
    end
end

assign out = state;  // Output is directly driven by the state

endmodule