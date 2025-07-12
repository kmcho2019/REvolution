module TopModule (
    input  clk,
    input  in,
    input  reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam WAIT_STOP = 2'd2;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE:
                next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE:
                if (bit_count == 3'd7)
                    next_state = (in == 1'b1) ? IDLE : WAIT_STOP; // check stop bit next cycle
                else
                    next_state = RECEIVE;
            WAIT_STOP:
                next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            default:
                next_state = IDLE;
        endcase
    end

    // Sequential logic: state, bit_count, data_shift, out_byte, done
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_shift <= 8'd0;
                end
                RECEIVE: begin
                    // shift in LSB first: shift right, insert new bit at MSB position
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;
                    if (bit_count == 3'd7) begin
                        // On next clock, 'in' is stop bit, processed in next_state logic
                        // done asserted next cycle if stop bit correct
                    end
                end
                WAIT_STOP: begin
                    // hold data_shift and bit_count until line idle
                end
            endcase

            // Assert done and latch output when returning to IDLE from RECEIVE with correct stop bit
            if (state == RECEIVE && bit_count == 3'd7 && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;
            end
        end
    end

endmodule