module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg done
);

    // State encoding
    localparam IDLE      = 2'b00,
               RECEIVE   = 2'b01,
               STOP_BIT  = 2'b10,
               WAIT_STOP = 2'b11;

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
            done <= 1'b0; // Default done low each cycle

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift left, input bit at LSB (LSB-first)
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 3'd1;
                end

                STOP_BIT: begin
                    // No shift or bit_count update; sample stop bit in combinational logic
                end

                WAIT_STOP: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    // Remain here until stop bit detected
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in == 1'b0)       // start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP_BIT; // after 8 bits received, check stop bit next cycle
                else
                    next_state = RECEIVE;
            end

            STOP_BIT: begin
                if (in == 1'b1)
                    next_state = IDLE;       // correct stop bit, back to idle
                else
                    next_state = WAIT_STOP;  // error, wait for stop bit
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;       // stop bit found, back to idle
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // done signal asserted one cycle after receiving valid stop bit
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
        end else begin
            // Assert done high for one cycle immediately after valid stop bit
            if (state == STOP_BIT && in == 1'b1)
                done <= 1'b1;
            else
                done <= 1'b0;
        end
    end

endmodule