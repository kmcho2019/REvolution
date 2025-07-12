module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

reg [2:0] state; // 3-bit state variable
reg [4:0] shift_reg; // 5-bit shift register

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000; // Reset state
        shift_reg <= 5'b00000; // Reset shift register
        MATCH <= 1'b0; // Reset MATCH signal
    end else begin
        case (state)
            3'b000: begin // Initial state
                if (IN == 1'b1) begin
                    state <= 3'b001; // Move to next state
                    shift_reg <= {IN, 4'b0000}; // Shift input sequence
                end else begin
                    state <= 3'b000; // Stay in initial state
                    shift_reg <= 5'b00000; // Reset shift register
                end
                MATCH <= 1'b0; // Reset MATCH signal
            end
            3'b001: begin // State 1
                if (IN == 1'b0) begin
                    state <= 3'b010; // Move to next state
                    shift_reg <= {IN, shift_reg[4:1]}; // Shift input sequence
                end else begin
                    state <= 3'b001; // Stay in state 1
                    shift_reg <= {IN, 4'b0000}; // Reset shift register
                end
                MATCH <= 1'b0; // Reset MATCH signal
            end
            3'b010: begin // State 2
                if (IN == 1'b0) begin
                    state <= 3'b011; // Move to next state
                    shift_reg <= {IN, shift_reg[4:1]}; // Shift input sequence
                end else begin
                    state <= 3'b001; // Move back to state 1
                    shift_reg <= {IN, 4'b0000}; // Reset shift register
                end
                MATCH <= 1'b0; // Reset MATCH signal
            end
            3'b011: begin // State 3
                if (IN == 1'b1) begin
                    state <= 3'b100; // Move to next state
                    shift_reg <= {IN, shift_reg[4:1]}; // Shift input sequence
                end else begin
                    state <= 3'b001; // Move back to state 1
                    shift_reg <= {IN, 4'b0000}; // Reset shift register
                end
                MATCH <= 1'b0; // Reset MATCH signal
            end
            3'b100: begin // State 4
                if (IN == 1'b1) begin
                    state <= 3'b000; // Move back to initial state
                    shift_reg <= 5'b00000; // Reset shift register
                    MATCH <= 1'b1; // Set MATCH signal
                end else begin
                    state <= 3'b001; // Move back to state 1
                    shift_reg <= {IN, 4'b0000}; // Reset shift register
                    MATCH <= 1'b0; // Reset MATCH signal
                end
            end
            default: begin
                state <= 3'b000; // Move back to initial state
                shift_reg <= 5'b00000; // Reset shift register
                MATCH <= 1'b0; // Reset MATCH signal
            end
        endcase
    end
end

endmodule