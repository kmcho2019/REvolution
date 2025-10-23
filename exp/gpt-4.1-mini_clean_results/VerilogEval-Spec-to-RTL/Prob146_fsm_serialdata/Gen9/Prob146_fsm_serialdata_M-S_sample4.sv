module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam WAIT_STOP = 2'd2;

    reg [1:0] state, next_state;
    reg [3:0] bit_count;   // counts 0 to 8 (start at 0)

    reg [7:0] data_shift;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;

            case(state)
                IDLE: begin
                    if (in == 1'b0) begin
                        bit_count <= 4'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Shift in data bits LSB first during bits 0-7
                    // At bit_count == 8, last bit is stop bit
                    if (bit_count < 4'd8) begin
                        if (bit_count < 4'd8) begin
                            if (bit_count < 4'd8) begin
                                if (bit_count < 4'd8) begin
                                    if (bit_count < 4'd8) begin
                                        // shift in bit at each count < 8
                                        if (bit_count < 4'd8) begin
                                            if (bit_count < 4'd8) begin
                                                // simplified to one shift per clock
                                                // shift bit in LSB first
                                                data_shift <= {in, data_shift[7:1]};
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        bit_count <= bit_count + 1;
                    end
                end

                WAIT_STOP: begin
                    // hold registers
                end
            endcase

            // Latch out_byte and assert done when RECEIVE finishes stop bit and stop bit is valid
            if (state == RECEIVE && bit_count == 4'd8) begin
                if (in == 1'b1) begin
                    out_byte <= data_shift;
                    done <= 1'b1;
                end
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 4'd8) begin
                    if (in == 1'b1)
                        next_state = IDLE;       // good stop bit, ready for next byte
                    else
                        next_state = WAIT_STOP;  // bad stop bit, wait for idle
                end else
                    next_state = RECEIVE;
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

endmodule