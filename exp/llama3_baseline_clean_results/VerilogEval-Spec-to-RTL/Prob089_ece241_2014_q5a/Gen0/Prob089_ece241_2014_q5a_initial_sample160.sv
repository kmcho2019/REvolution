module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // 0: idle/reset, 1: inverting, 2: adding (not actually needed for Moore)
reg [7:0] acc; // Accumulator to hold the inverted bits
reg carry; // Carry for the addition part of 2's complement
reg prev_x; // Previous input to detect when to start/stop conversion

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        acc <= 0;
        carry <= 0;
        prev_x <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // Idle/Reset state
                if (~x) begin // Wait for x to go low to start conversion
                    state <= 1;
                    acc <= 0;
                    carry <= 0;
                end
            end
            1: begin // Inverting state
                if (x) begin // Invert the bit
                    acc <= {acc[6:0], ~x};
                end else begin // Don't invert if x is 0
                    acc <= {acc[6:0], x};
                end
                // If x goes high after being low, we've finished inverting
                if (~prev_x && x) begin
                    state <= 0; // Transition back to idle
                    // Output the complemented bit
                    z <= ~acc[7] ^ carry;
                end
                prev_x <= x;
            end
            default: state <= 0;
        endcase
    end
end

endmodule