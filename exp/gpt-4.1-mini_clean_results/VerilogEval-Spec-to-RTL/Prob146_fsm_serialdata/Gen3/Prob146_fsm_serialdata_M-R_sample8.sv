module TopModule(
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg [7:0]  out_byte,
    output reg        done
);

    // State encoding using localparams
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam STOP_WAIT  = 2'b10;
    localparam ERROR_WAIT = 2'b11;

    reg [1:0] state, next_state;
    reg [7:0] data_shift;
    reg [3:0] bit_count;

    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            data_shift <= 8'b0;
            bit_count  <= 4'b0;
            out_byte   <= 8'b0;
            done       <= 1'b0;
        end else begin
            done <= 1'b0; // default done low each clock

            case (state)
                IDLE: begin
                    done <= 1'b0;
                    bit_count <= 4'b0;
                    data_shift <= 8'b0;
                    if (in == 1'b0) // start bit detected
                        state <= RECEIVE;
                    else
                        state <= IDLE;
                end

                RECEIVE: begin
                    // Shift in LSB first: shift left and put in bit at LSB
                    data_shift <= {in, data_shift[7:1]}; // Wait, this shifts in MSB first - need to shift right for LSB first
                    bit_count <= bit_count + 1;

                    if (bit_count == 4'd7)
                        state <= STOP_WAIT;
                    else
                        state <= RECEIVE;
                end

                STOP_WAIT: begin
                    if (in == 1'b1) begin // valid stop bit
                        out_byte <= data_shift;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        // invalid stop bit, enter error wait
                        state <= ERROR_WAIT;
                    end
                end

                ERROR_WAIT: begin
                    if (in == 1'b1)
                        state <= IDLE;
                    else
                        state <= ERROR_WAIT;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule