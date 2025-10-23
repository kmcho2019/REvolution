module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam STOP      = 2'd2;
    localparam WAIT_STOP = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count; // count 0..7
    reg [7:0] data_shift;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Default done cleared
            done <= 1'b0;

            case (state)
                IDLE: begin
                    // When start bit detected, reset bit_count and data_shift
                    if (next_state == RECEIVE) begin
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Shift right by 1, insert new bit into MSB (LSB first serial)
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 3'd1;
                end

                STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= data_shift;
                        done <= 1'b1;
                    end
                    // else no done, wait in WAIT_STOP state
                end

                WAIT_STOP: begin
                    // hold registers stable to reduce toggling
                    // no updates needed
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE; // start bit detected
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
                    next_state = IDLE;     // good stop bit
                else
                    next_state = WAIT_STOP; // wait for stop bit
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