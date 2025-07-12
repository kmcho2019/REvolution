module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    // One-hot state encoding
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;

    // bit counter for data bits received
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg       done_reg;

    // Next state combinational logic (one-hot)
    always @(*) begin
        case (1'b1)
            state[0]: // IDLE
                next_state = (in == 1'b0) ? RECEIVE : IDLE;
            state[1]: // RECEIVE
                next_state = (bit_count == 3'd7) ? CHECK_STOP : RECEIVE;
            state[2]: // CHECK_STOP
                next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            state[3]: // WAIT_STOP
                next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            default:
                next_state = IDLE;
        endcase
    end

    // done signal combinational logic (set high one cycle on valid stop bit)
    assign done = done_reg;

    // Sequential logic: state update, shift register, bit counter, done pulse
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done_reg  <= 1'b0;
        end else begin
            state <= next_state;
            done_reg <= 1'b0; // default done low unless set below

            case (1'b1)
                state[0]: begin // IDLE
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                state[1]: begin // RECEIVE
                    // Shift left by 1, load new bit into LSB (LSB first)
                    shift_reg <= {shift_reg[6:0], in};
                    bit_count <= bit_count + 1'b1;
                end

                state[2]: begin // CHECK_STOP
                    bit_count <= 3'd0;
                    // done asserted when stop bit is correct
                    if (in == 1'b1)
                        done_reg <= 1'b1;
                end

                state[3]: begin // WAIT_STOP
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                default: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule