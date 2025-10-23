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
    reg [2:0] bit_count; // count from 0 to 7
    reg [7:0] data_shift;

    // Sequential logic with clock enable on bit_count and data_shift
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low, asserted only in STOP state when correct stop bit detected
            done <= 1'b0;

            case (state)
                IDLE: begin
                    // Reset bit_count and data_shift only when start bit detected (in IDLE)
                    if (in == 1'b0 && next_state == RECEIVE) begin
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Update only in RECEIVE state
                    data_shift <= {in, data_shift[7:1]}; // shift in LSB first
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    if (in == 1'b1) begin
                        // Valid stop bit: latch data and signal done
                        out_byte <= data_shift;
                        done <= 1'b1;
                    end
                    // else no done signal; wait in WAIT_STOP state to resync
                end

                WAIT_STOP: begin
                    // No register updates here to save toggling
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;  // start bit detected
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
                    next_state = IDLE;    // good stop bit, ready for next byte
                else
                    next_state = WAIT_STOP; // bad stop bit, wait for line idle
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;    // line idle regained, restart
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule