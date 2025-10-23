module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

reg [4:0] state; // 5-bit state register
reg [3:0] shift_reg; // 4-bit shift register

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 5'b00000; // Reset state
        shift_reg <= 4'b0000; // Reset shift register
    end else begin
        shift_reg <= {IN, shift_reg[3:1]}; // Shift input sequence
        case (state)
            5'b00000: begin // S0
                if (IN) begin
                    state <= 5'b00001; // Transition to S1
                end else begin
                    state <= 5'b00000; // Stay in S0
                end
            end
            5'b00001: begin // S1
                if (!IN) begin
                    state <= 5'b00010; // Transition to S2
                end else begin
                    state <= 5'b00001; // Stay in S1
                end
            end
            5'b00010: begin // S2
                if (!IN) begin
                    state <= 5'b00100; // Transition to S3
                end else begin
                    state <= 5'b00001; // Transition to S1
                end
            end
            5'b00100: begin // S3
                if (IN) begin
                    state <= 5'b01000; // Transition to S4
                end else begin
                    state <= 5'b00010; // Transition to S2
                end
            end
            5'b01000: begin // S4
                if (IN) begin
                    state <= 5'b10000; // Transition to S5
                end else begin
                    state <= 5'b00100; // Transition to S3
                end
            end
            5'b10000: begin // S5
                state <= 5'b00000; // Transition to S0
            end
            default: state <= 5'b00000; // Default state
        endcase
    end
end

assign MATCH = (state == 5'b10000) && (shift_reg == 4'b10011)? 1'b1 : 1'b0; // Set MATCH signal to 1 when in S5 state

endmodule