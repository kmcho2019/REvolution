module TopModule(
    input clk,
    input reset,
    input data,
    output start_shifting
);

reg [1:0] state; // 2 bits to represent the four states
reg start_shifting_reg;

always @(posedge clk) begin
    if (reset) begin // reset is active high
        state <= 2'b00; // IDLE state
        start_shifting_reg <= 0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (data) begin
                    state <= 2'b01; // transition to FIRST_1 state
                end
            end
            2'b01: begin // FIRST_1 state
                if (data) begin
                    state <= 2'b10; // transition to FIRST_1_ONE state
                end else begin
                    state <= 2'b11; // transition to FIRST_1_ZERO state
                end
            end
            2'b10: begin // FIRST_1_ONE state
                if (data) begin
                    // we don't have a state for the correct sequence, so stay here
                end else begin
                    state <= 2'b00; // transition back to IDLE state
                end
            end
            2'b11: begin // FIRST_1_ZERO state
                if (data) begin
                    start_shifting_reg <= 1; // found the sequence, set start_shifting to 1
                    state <= 2'b10; // transition to FIRST_1_ONE state
                end else begin
                    state <= 2'b00; // transition back to IDLE state
                end
            end
            default: state <= 2'b00; // transition to IDLE state
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule