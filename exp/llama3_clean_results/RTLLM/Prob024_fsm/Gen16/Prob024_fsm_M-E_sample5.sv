module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

reg [2:0] state; // 3-bit state register
reg [4:0] pipe_reg; // 5-bit pipeline register

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000; // Reset state
        pipe_reg <= 5'b00000; // Reset pipeline register
    end else begin
        case (state)
            3'b000: begin // S0
                if (IN) begin
                    state <= 3'b001; // Transition to S1
                    pipe_reg <= {IN, 4'b0000}; // Shift input sequence
                end else begin
                    state <= 3'b000; // Stay in S0
                    pipe_reg <= {1'b0, pipe_reg[4:1]}; // Shift zeros
                end
            end
            3'b001: begin // S1
                if (!IN) begin
                    state <= 3'b010; // Transition to S2
                    pipe_reg <= {IN, pipe_reg[4:1]}; // Shift input sequence
                end else begin
                    state <= 3'b001; // Stay in S1
                    pipe_reg <= {1'b1, pipe_reg[4:1]}; // Shift ones
                end
            end
            3'b010: begin // S2
                if (!IN) begin
                    state <= 3'b011; // Transition to S3
                    pipe_reg <= {IN, pipe_reg[4:1]}; // Shift input sequence
                end else begin
                    state <= 3'b001; // Transition to S1
                    pipe_reg <= {1'b1, pipe_reg[4:1]}; // Shift ones
                end
            end
            3'b011: begin // S3
                if (IN) begin
                    state <= 3'b100; // Transition to S4
                    pipe_reg <= {IN, pipe_reg[4:1]}; // Shift input sequence
                end else begin
                    state <= 3'b010; // Transition to S2
                    pipe_reg <= {1'b0, pipe_reg[4:1]}; // Shift zeros
                end
            end
            3'b100: begin // S4
                if (IN) begin
                    state <= 3'b101; // Transition to S5
                    pipe_reg <= {IN, pipe_reg[4:1]}; // Shift input sequence
                end else begin
                    state <= 3'b011; // Transition to S3
                    pipe_reg <= {1'b0, pipe_reg[4:1]}; // Shift zeros
                end
            end
            3'b101: begin // S5
                state <= 3'b000; // Transition to S0
                pipe_reg <= {IN, pipe_reg[4:1]}; // Shift input sequence
            end
            default: state <= 3'b000; // Default state
        endcase
    end
end

assign MATCH = (state == 3'b101)? 1'b1 : 1'b0; // Set MATCH signal to 1 when in S5 state

endmodule