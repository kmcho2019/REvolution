module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

reg [2:0] state; // State machine states
reg [4:0] shift_reg; // 5-bit shift register
reg [1:0] count; // Counter for state machine

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000; // Reset state machine
        shift_reg <= 5'b00000; // Reset shift register
        count <= 2'b00; // Reset counter
        MATCH <= 1'b0; // Reset MATCH signal
    end else begin
        case (state)
            3'b000: begin // IDLE state
                if (IN == 1'b1) begin
                    state <= 3'b001; // Transition to S1
                    shift_reg <= {IN, 4'b0000}; // Shift input sequence
                    count <= 2'b01; // Increment counter
                end else begin
                    shift_reg <= {IN, shift_reg[4:1]}; // Shift input sequence
                end
            end
            3'b001: begin // S1 state
                if (IN == 1'b0) begin
                    state <= 3'b010; // Transition to S2
                    shift_reg <= {IN, shift_reg[4:1]}; // Shift input sequence
                    count <= 2'b10; // Increment counter
                end else begin
                    state <= 3'b000; // Reset state machine
                    shift_reg <= {IN, 4'b0000}; // Reset shift register
                    count <= 2'b00; // Reset counter
                end
            end
            3'b010: begin // S2 state
                if (IN == 1'b0) begin
                    state <= 3'b011; // Transition to S3
                    shift_reg <= {IN, shift_reg[4:1]}; // Shift input sequence
                    count <= 2'b11; // Increment counter
                end else begin
                    state <= 3'b000; // Reset state machine
                    shift_reg <= {IN, 4'b0000}; // Reset shift register
                    count <= 2'b00; // Reset counter
                end
            end
            3'b011: begin // S3 state
                if (IN == 1'b1) begin
                    state <= 3'b100; // Transition to S4
                    shift_reg <= {IN, shift_reg[4:1]}; // Shift input sequence
                    count <= 2'b01; // Reset counter
                end else begin
                    state <= 3'b000; // Reset state machine
                    shift_reg <= {IN, 4'b0000}; // Reset shift register
                    count <= 2'b00; // Reset counter
                end
            end
            3'b100: begin // S4 state
                if (IN == 1'b1) begin
                    state <= 3'b101; // Transition to MATCH
                    shift_reg <= {IN, shift_reg[4:1]}; // Shift input sequence
                    count <= 2'b10; // Increment counter
                    MATCH <= 1'b1; // Assert MATCH signal
                end else begin
                    state <= 3'b000; // Reset state machine
                    shift_reg <= {IN, 4'b0000}; // Reset shift register
                    count <= 2'b00; // Reset counter
                end
            end
            3'b101: begin // MATCH state
                MATCH <= 1'b0; // Deassert MATCH signal
                state <= 3'b000; // Reset state machine
                shift_reg <= {IN, 4'b0000}; // Reset shift register
                count <= 2'b00; // Reset counter
            end
        endcase
    end
end

endmodule