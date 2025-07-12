module TopModule (
    input  clk,
    input  in,
    input  reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE      = 2'b00,
        RECEIVE   = 2'b01,
        STOP      = 2'b10,
        WAIT_STOP = 2'b11
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE; // Detect start bit
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Data shift and bit_count update
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 3'd0;
            data_shift <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    // Clear registers on detection of start bit (falling edge detected by next_state)
                    if (in == 1'b0) begin
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Shift in LSB first: on each clock sample input 'in' into LSB
                    // Right shift previous bits and put new bit at MSB place
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;
                end

                default: begin
                    // No changes to bit_count or data_shift in STOP or WAIT_STOP
                    bit_count <= bit_count;
                    data_shift <= data_shift;
                end
            endcase
        end
    end

    // Output logic and done signal generation
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            // Default done deasserted
            done <= 1'b0;

            // When in STOP state and stop bit correct, latch output and assert done
            if (state == STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;
            end
        end
    end

endmodule