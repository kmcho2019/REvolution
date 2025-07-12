module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg done
);

    // State encoding
    localparam IDLE      = 2'b00,
               RECEIVE   = 2'b01,
               WAIT_STOP = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;   // 3 bits for counting 0 to 7
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low each cycle

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift in the input bit at LSB, shift right for LSB first
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 3'd1;
                    if (bit_count == 3'd7) begin
                        // After receiving 8 data bits, check stop bit in next cycle
                        // done and next_state handled in combinational logic
                    end
                end

                WAIT_STOP: begin
                    bit_count <= 3'd0;
                    // hold shift_reg stable
                end
            endcase

            // done is asserted in the next cycle after verifying stop bit == 1
            if (state == RECEIVE && bit_count == 3'd7 && in == 1'b1) begin
                done <= 1'b1;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7) begin
                    // After 8 data bits, check stop bit
                    if (in == 1'b1)
                        next_state = IDLE;       // Correct stop bit, ready for next byte
                    else
                        next_state = WAIT_STOP;  // Error, wait for stop bit
                end else begin
                    next_state = RECEIVE;
                end
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE; // Stop bit detected, back to idle
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule