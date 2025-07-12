module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg state; // 1-bit register to hold the current state
always @(posedge clk or posedge areset) begin
    if (areset) begin // asynchronous reset
        state <= 0; // Reset state to OFF
    end else begin
        case (state)
            0: begin // State OFF
                if (j) begin
                    state <= 1; // Transition to ON if j=1
                end else begin
                    state <= 0; // Stay in OFF if j=0
                end
            end
            1: begin // State ON
                if (k) begin
                    state <= 0; // Transition to OFF if k=1
                end else begin
                    state <= 1; // Stay in ON if k=0
                end
            end
            default: state <= 0; // Default case for synthesis
        endcase
    end
end

// Output is a function of the current state (Moore machine)
assign out = state;

endmodule