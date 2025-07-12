module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg [7:0]  out_byte,
    output reg        done
);

    // One-hot state encoding for clarity and ease of debugging
    localparam IDLE          = 5'b00001;
    localparam START_WAIT    = 5'b00010;
    localparam DATA_RECEIVE  = 5'b00100;
    localparam STOP_CHECK    = 5'b01000;
    localparam ERROR_RECOVERY= 5'b10000;

    reg [4:0] state, next_state;

    reg [2:0] bit_count;    // Counts data bits received: 0 to 7
    reg [7:0] shift_reg;    // Shift register for incoming data bits

    // Sequential logic: state, bit_count, shift_reg, done, out_byte
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            out_byte  <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // default no done pulse

            case (state)
                IDLE: begin
                    // Nothing to do, wait for start bit
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                START_WAIT: begin
                    // Just wait and confirm start bit still low next cycle
                    // No registers updated here
                end

                DATA_RECEIVE: begin
                    // Shift in bit LSB first: shift left, input bit into LSB
                    // Example: new data bit goes into LSB, old bits shift left
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                STOP_CHECK: begin
                    // Check stop bit: if 1 => valid stop, output byte and done pulse
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                    // else don't update out_byte or done here
                end

                ERROR_RECOVERY: begin
                    // Wait for line to return to idle (1)
                    // No registers updated
                end

                default: ;
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state; // default hold

        case (state)
            IDLE: begin
                // Wait for start bit 0
                if (in == 1'b0)
                    next_state = START_WAIT;
                else
                    next_state = IDLE;
            end

            START_WAIT: begin
                // Confirm start bit still low, else false start
                if (in == 1'b0)
                    next_state = DATA_RECEIVE;
                else
                    next_state = IDLE;
            end

            DATA_RECEIVE: begin
                // When 8 bits received move to STOP_CHECK
                if (bit_count == 3'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = DATA_RECEIVE;
            end

            STOP_CHECK: begin
                // If stop bit valid => done and go IDLE
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_RECOVERY;
            end

            ERROR_RECOVERY: begin
                // Wait until line goes idle before accepting new start bit
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_RECOVERY;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule