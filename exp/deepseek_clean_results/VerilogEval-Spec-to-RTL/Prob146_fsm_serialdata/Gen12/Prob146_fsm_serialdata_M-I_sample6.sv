module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Optimized FSM states
    localparam IDLE    = 1'b0;
    localparam RECEIVE = 1'b1;

    reg state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;

    // Registered next_state for better timing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;  // Default to 0 (single-cycle pulse)
            
            if (shift_enable) begin
                shift_reg <= {shift_reg[6:0], in};  // Left shift (LSB first)
                bit_count <= bit_count + 1;
            end

            // Capture output and assert done when stop bit is valid
            if (state == RECEIVE && bit_count == 3'b111 && in) begin
                out_byte <= {shift_reg[6:0], in};  // Final shift + capture
                done <= 1'b1;
            end
        end
    end

    // Next state and control logic
    always @(*) begin
        next_state = state;
        shift_enable = 1'b0;

        case (state)
            IDLE: begin
                if (!in) begin  // Start bit detected
                    next_state = RECEIVE;
                    shift_enable = 1'b1;
                end
            end
            
            RECEIVE: begin
                if (bit_count < 3'b111) begin
                    shift_enable = 1'b1;
                end else begin
                    // After 8 bits, check stop bit and return to IDLE
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule