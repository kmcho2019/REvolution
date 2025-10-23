module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding
    localparam IDLE  = 2'd0;
    localparam DATA  = 2'd1;
    localparam STOP  = 2'd2;
    localparam ERROR = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Next state combinational logic
    always @(*) begin
        case(state)
            IDLE: 
                // Wait for start bit (0)
                next_state = (in == 1'b0) ? DATA : IDLE;

            DATA:
                // After 8 bits, move to STOP
                next_state = (bit_count == 3'd7) ? STOP : DATA;

            STOP:
                // If stop bit is 1, done and return to IDLE
                // Else enter ERROR to wait for stop bit
                next_state = (in == 1'b1) ? IDLE : ERROR;

            ERROR:
                // Remain in ERROR until stop bit 1 seen
                next_state = (in == 1'b1) ? IDLE : ERROR;

            default:
                next_state = IDLE;
        endcase
    end

    // Sequential logic: state, counters, shift reg, done signal
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0;  // Default done low

            case(state)
                IDLE: begin
                    // Reset counters and shift register only here for minimal toggling
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                DATA: begin
                    // Shift in LSB first: new bit into bit 0, shift right
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                STOP: begin
                    // If stop bit correct, pulse done
                    if (in == 1'b1)
                        done <= 1'b1;
                    // Prepare counters for next reception on next IDLE
                    bit_count <= 3'd0;
                    // Keep shift_reg stable (contains last received byte)
                end

                ERROR: begin
                    // Reset counters and shift register while waiting for valid stop bit
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                default: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    done      <= 1'b0;
                end
            endcase
        end
    end

endmodule