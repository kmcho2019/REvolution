module TopModule(
    input  wire        clk,
    input  wire        in,
    input  wire        reset,
    output reg  [7:0]  out_byte,
    output reg         done
);

    typedef enum logic [1:0] {
        IDLE    = 2'd0,
        RECEIVE = 2'd1,
        STOP    = 2'd2
    } state_t;

    state_t state, next_state;

    reg [7:0] data_shift;
    reg [3:0] bit_count;  // counts from 0 to 7 for data bits

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
                if (bit_count == 4'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            data_shift <= 8'd0;
            bit_count  <= 4'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0;  // default no done pulse

            case(state)
                IDLE: begin
                    bit_count  <= 4'd0;
                    data_shift <= 8'd0;
                    // Wait for start bit (in == 0)
                end

                RECEIVE: begin
                    // Shift in LSB first: shift left, put new bit at LSB
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    if (in == 1'b1) begin
                        // Valid stop bit: output byte and assert done
                        out_byte <= data_shift;
                        done <= 1'b1;
                    end
                    // else remain in STOP waiting for stop bit 1 without done
                end

                default: ; // no action
            endcase
        end
    end

endmodule