module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // State register, 0 for OFF, 1 for ON
reg next_state; // Next state register

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to OFF state
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        0: begin // OFF state
            if (j) begin
                next_state = 1; // Transition to ON
            end else begin
                next_state = 0; // Stay in OFF
            end
        end
        1: begin // ON state
            if (k) begin
                next_state = 0; // Transition to OFF
            end else begin
                next_state = 1; // Stay in ON
            end
        end
    endcase
end

assign out = state; // Output determined by current state

endmodule