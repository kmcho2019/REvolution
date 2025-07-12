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
    reg [2:0] bit_count;      // counts 0..7 data bits received
    reg [7:0] data_shift;     // shift register for data bits, LSB first

    // FSM sequential logic and outputs
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            bit_count  <= 3'd0;
            data_shift <= 8'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low, asserted only for one cycle on valid stop bit
            done <= 1'b0;

            case (state)
                IDLE: begin
                    // Clear counters when start bit detected (next_state == RECEIVE)
                    if (next_state == RECEIVE) begin
                        bit_count  <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Shift in serial bit LSB first at each bit_count increment
                    data_shift <= {in, data_shift[7:1]};
                    bit_count  <= bit_count + 1'b1;
                end

                STOP: begin
                    if (in == 1'b1) begin
                        // Valid stop bit: latch output and pulse done
                        out_byte <= data_shift;
                        done <= 1'b1;
                    end
                    // else wait for resync in WAIT_STOP
                end

                WAIT_STOP: begin
                    // Hold everything stable, waiting for line idle (in == 1)
                    // No register updates to minimize toggling
                end
            endcase
        end
    end

    // FSM combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;   // start bit detected
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP;      // after 8 data bits
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;      // good stop bit, ready for next byte
                else
                    next_state = WAIT_STOP; // bad stop bit, wait for line idle
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;      // resync after bad stop bit
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule