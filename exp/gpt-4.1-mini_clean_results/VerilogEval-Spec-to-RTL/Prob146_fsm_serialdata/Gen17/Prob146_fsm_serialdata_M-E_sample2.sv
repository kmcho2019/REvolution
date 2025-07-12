module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg [7:0]  out_byte,
    output reg        done
);

    // State encoding with one-hot style for clarity
    localparam IDLE       = 3'b001;
    localparam READING    = 3'b010;
    localparam STOP_CHECK = 3'b100;
    localparam WAIT_STOP  = 3'b000; // use zero pattern to represent WAIT_STOP for explicit checking

    reg [2:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    // Synchronous state and data register update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte  <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // default done low

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_shift <= 8'd0;
                    if (in == 1'b0) begin
                        // Start bit detected: move to READING on next clock
                        // data_shift and bit_count cleared above
                    end
                end

                READING: begin
                    // Shift in LSB first: shift right, place new bit at MSB
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 3'd1;
                end

                STOP_CHECK: begin
                    if (in == 1'b1) begin
                        out_byte <= data_shift;
                        done <= 1'b1; // valid byte received
                    end
                end

                WAIT_STOP: begin
                    // Just wait for stop bit (logic 1)
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = READING;
                else
                    next_state = IDLE;
            end

            READING: begin
                if (bit_count == 3'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = READING;
            end

            STOP_CHECK: begin
                if (in == 1'b1)
                    next_state = IDLE;      // Valid stop bit, ready for next byte
                else
                    next_state = WAIT_STOP; // Invalid stop bit, wait for correct stop bit
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