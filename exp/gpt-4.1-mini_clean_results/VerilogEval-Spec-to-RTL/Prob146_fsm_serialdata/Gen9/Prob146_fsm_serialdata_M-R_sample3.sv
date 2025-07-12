module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // Binary encoded states
    localparam IDLE      = 3'b000;
    localparam RECEIVE   = 3'b001;
    localparam STOP      = 3'b010;
    localparam WAIT_STOP = 3'b011;

    reg [2:0] state, next_state;
    reg [2:0] bit_count;       // 3-bit counter for 8 bits
    reg [7:0] data_shift;

    wire receive_enable = (state == RECEIVE);

    // Sequential logic: state, counters, shift register, outputs
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            bit_count  <= 3'd0;
            data_shift <= 8'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0;  // default done low

            case(state)
                IDLE: begin
                    if (in == 1'b0) begin // start bit detected
                        bit_count  <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Shift in LSB first by shifting right and inserting at MSB
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                STOP: begin
                    if (in == 1'b1) begin // valid stop bit
                        out_byte <= data_shift;
                        done <= 1'b1;
                    end
                end

                WAIT_STOP: begin
                    // wait for line idle
                end

                default: begin
                    // should never occur; safe reset
                    bit_count  <= 3'd0;
                    data_shift <= 8'd0;
                    done       <= 1'b0;
                end
            endcase
        end
    end

    // Combinational next-state logic
    always @(*) begin
        next_state = state; // default stay in current state

        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE; // start bit detected
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP; // all 8 bits received
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE; // valid stop bit, ready for next byte
                else
                    next_state = WAIT_STOP; // wait until stop bit is valid
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE; // line idle, can start again
            end

            default: next_state = IDLE;
        endcase
    end

endmodule