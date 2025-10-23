module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg [7:0]  out_byte,
    output reg        done
);

    typedef enum logic [1:0] {
        IDLE    = 2'd0,
        RECEIVE = 2'd1,
        STOP    = 2'd2
    } state_t;

    state_t state, next_state;

    reg [7:0] data_shift; // shift register for incoming bits (received MSB first)
    reg [3:0] bit_count;  // counts number of data bits received: 0 to 7

    // State register with synchronous reset
    always_ff @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            data_shift <= 8'd0;
            bit_count  <= 4'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
        end else begin
            done <= 1'b0;  // default no done pulse

            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        // Start bit detected, go to RECEIVE
                        state     <= RECEIVE;
                        bit_count <= 4'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Shift in data bits LSB first:
                    // Shift right by one, insert new bit at MSB
                    // We will reverse at the end before output
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;

                    if (bit_count == 4'd7) begin
                        state <= STOP;
                    end
                end

                STOP: begin
                    if (in == 1'b1) begin
                        // Valid stop bit, output reversed byte and assert done
                        out_byte <= {data_shift[0], data_shift[1], data_shift[2], data_shift[3],
                                     data_shift[4], data_shift[5], data_shift[6], data_shift[7]};
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        // Invalid stop bit, wait here until stop bit is 1
                        state <= STOP;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule