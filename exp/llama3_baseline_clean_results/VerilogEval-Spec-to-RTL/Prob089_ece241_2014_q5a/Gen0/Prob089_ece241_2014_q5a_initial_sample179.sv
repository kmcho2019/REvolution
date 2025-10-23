module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // 0: initial, waiting for first 1; 1: inverting and adding 1
reg carry; // Carry for adding 1 in 2's complement

always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= 0;
        carry <= 0;
    end else begin
        case(state)
            0: begin // Waiting for first '1'
                if (x) begin // First '1' encountered, move to inverting and adding state
                    state <= 1;
                    carry <= 1; // Start adding 1
                end else begin // Keep inverting
                    state <= 0;
                    carry <= 0;
                end
            end
            1: begin // Inverting and adding 1
                // Once we've started inverting and adding, we remain in this state until reset
                state <= 1;
                // Update carry for next cycle, considering current input bit
                carry <= ~x & carry; // If input is '1' and we have a carry, propagate it
            end
            default: state <= 0;
        endcase
    end
end

always @(*) begin
    case(state)
        0: z = ~x; // Initially, just invert the input
        1: z = ~(x ^ carry); // After first '1', invert and add carry
        default: z = 1'b0;
    endcase
end

endmodule