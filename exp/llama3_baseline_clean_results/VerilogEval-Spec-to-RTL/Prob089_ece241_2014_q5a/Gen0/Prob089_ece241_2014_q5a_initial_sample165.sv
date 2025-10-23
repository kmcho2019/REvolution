module TopModule(
    input           clk,
    input           areset,
    input           x,
    output reg      z
);

reg [1:0] state; // 0: IDLE, 1: INVERT, 2: UNUSED

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Reset to IDLE state
        z <= 1'b0;  // Reset output to 0
    end else begin
        case(state)
            0: begin // IDLE state
                if (x == 1'b1) begin
                    state <= 1; // Transition to INVERT state
                    z <= 1'b1;  // First bit is always 1 in 2's complement
                end else begin
                    state <= 0; // Stay in IDLE state
                    z <= 1'b0;  // Output 0 for leading zeros
                end
            end
            1: begin // INVERT state
                z <= ~x; // Invert bits
            end
            default: begin
                state <= 0; // Stay in IDLE state for unused states
                z <= 1'b0;
            end
        endcase
    end
end

endmodule