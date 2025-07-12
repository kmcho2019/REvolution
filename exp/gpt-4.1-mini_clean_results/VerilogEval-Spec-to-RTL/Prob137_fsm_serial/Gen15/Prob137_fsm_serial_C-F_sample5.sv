module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding using localparam for clarity and synthesis friendliness
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)      // Detect start bit
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end
            CHECK_STOP: begin
                if (in == 1'b1)       // Valid stop bit
                    next_state = IDLE;
                else                  // Framing error, wait for stop bit
                    next_state = WAIT_STOP;
            end
            WAIT_STOP: begin
                if (in == 1'b1)       // Stop bit received, go idle
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, shift register, bit count, done pulse generation
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low; asserted only for one cycle after correct stop bit
            done <= 1'b0;

            case (state)
                IDLE: begin
                    shift_reg <= 8'd0;
                    bit_count <= 3'd0;
                end

                RECEIVE: begin
                    // Shift right, load new bit into MSB (LSB first serial input)
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                CHECK_STOP: begin
                    bit_count <= 3'd0;
                    // Pulse done high one cycle if stop bit is correct
                    if (in == 1'b1)
                        done <= 1'b1;
                end

                WAIT_STOP: begin
                    shift_reg <= 8'd0;
                    bit_count <= 3'd0;
                end
            endcase
        end
    end

endmodule