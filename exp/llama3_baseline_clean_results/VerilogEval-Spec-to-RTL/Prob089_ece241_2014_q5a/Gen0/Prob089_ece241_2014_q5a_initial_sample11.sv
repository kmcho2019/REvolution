module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state = 2'b00; // State: 00 - idle, 01 - complementing, 10 - not used
reg carry = 1'b0; // Carry for 2's complement

always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= 2'b00;
        carry <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (x == 1'b1) begin // Start of input
                    state <= 2'b01; // Transition to complementing state
                    carry <= 1'b1; // Initial carry for 2's complement
                end
            end
            2'b01: begin // Complementing state
                // No change in state, continue complementing
                carry <= ~carry; // Update carry
            end
        endcase
    end
end

always @(state or carry or x) begin
    case (state)
        2'b00: z = 1'b0; // Idle state, output '0'
        2'b01: z = ~carry; // Complementing state, output inverted carry
    endcase
end

endmodule