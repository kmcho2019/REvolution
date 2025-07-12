module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg done
);

    // State encoding
    localparam IDLE    = 2'd0;
    localparam DATA    = 2'd1;
    localparam STOP    = 2'd2;
    localparam RECOVER = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Sequential logic: state, bit_count, shift_reg, done
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0;  // default no pulse unless set below

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                DATA: begin
                    // Shift right: insert new bit at MSB, accumulating LSB-first serial bits
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                STOP: begin
                    // done pulse generated synchronously for one clock cycle on valid stop bit (in=1)
                    if (in == 1'b1)
                        done <= 1'b1;
                    // else no done, next state logic handles recovery
                end

                RECOVER: begin
                    // Hold bit_count and shift_reg as-is (no updates)
                end

                default: begin
                    // Defensive default reset values
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE;
            end

            DATA: begin
                // After receiving 8 bits (bit_count == 7), move to STOP state
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end

            STOP: begin
                // If stop bit correct (in=1), go to IDLE (done pulse will be generated)
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    // Stop bit incorrect, wait in RECOVER state for valid stop bit
                    next_state = RECOVER;
            end

            RECOVER: begin
                // Wait until line goes high (stop bit=1) before restarting reception
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule