module TopModule (
    input  wire        clk,
    input  wire        in,
    input  wire        reset,
    output reg  [7:0]  out_byte,
    output reg         done
);

    // One-hot state encoding for clarity
    localparam [3:0]
        IDLE      = 4'b0001,
        RECEIVE   = 4'b0010,
        STOP      = 4'b0100,
        WAIT_STOP = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
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

    // Sequential logic: state update, counters, data shift, outputs
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            bit_count  <= 3'd0;
            data_shift <= 8'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
        end else begin
            state <= next_state;

            // Default done to 0; assert 1 only on valid byte reception
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_shift <= 8'd0;
                end
                RECEIVE: begin
                    // Shift in LSB first: input bit goes into MSB, shift right
                    // To shift LSB first, shift right and put 'in' into MSB or shift left and put into LSB.
                    // Protocol sends LSB first, so we shift right and insert new bit at MSB is incorrect.
                    // Instead shift left and insert new bit at LSB:
                    data_shift <= {in, data_shift[7:1]}; // This inserts at MSB, so reverse order
                    // Correction: since LSB first, we must shift right and insert bit at MSB (data_shift <= {in, data_shift[7:1]} is MSB-first)
                    // To shift in LSB first, new bit at MSB is wrong, new bit should go to LSB.

                    // Proper: shift right and insert 'in' at MSB is MSB-first. For LSB-first:
                    // shift right and insert 'in' at MSB --> first bit comes to MSB, next shifts right and data propagates right - not correct.
                    // shift left and insert in at LSB is correct: data_shift <= {data_shift[6:0], in};

                    data_shift <= {data_shift[6:0], in};
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= data_shift;
                        done <= 1'b1;
                    end
                end
                WAIT_STOP: begin
                    // nothing to update until stop bit is 1
                end
            endcase
        end
    end

endmodule