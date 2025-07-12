module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // 2 states: IDLE (2'b00) and CONVERT (2'b01)
reg [1:0] nextState; // Next state
reg bitStored; // 1 if a bit is stored, 0 otherwise
reg [31:0] bits; // Accumulated bits
reg sign; // Sign bit

always @(*) begin
    case(state)
        2'b00: begin // IDLE
            if (~areset) begin
                nextState = 2'b01; // Move to CONVERT state when reset is released
            end else begin
                nextState = 2'b00; // Stay in IDLE state when reset is asserted
            end
            z = 1'b0; // Output is 0 in IDLE state
        end
        2'b01: begin // CONVERT
            if (areset) begin
                nextState = 2'b00; // Move to IDLE state when reset is asserted
            end else begin
                nextState = 2'b01; // Stay in CONVERT state
            end
            if (~sign) begin // If sign bit is not set
                if (x) begin
                    sign = 1'b1; // Set sign bit
                    z = ~x; // Output is complement of sign bit
                end else begin
                    z = ~x; // Output is complement of input bit
                end
            end else begin
                z = ~x; // Output is complement of input bit
            end
        end
        default: begin
            nextState = 2'b00;
            z = 1'b0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        sign <= 1'b0;
        bits <= 32'b0;
    end else begin
        state <= nextState;
        if (state == 2'b01) begin
            if (~sign) begin
                if (x) begin
                    sign <= 1'b1;
                end
            end
        end
    end
end

endmodule