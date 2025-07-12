module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot state encoding
    localparam [3:0]
        IDLE       = 4'b0001,
        RECEIVE    = 4'b0010,
        CHECK_STOP = 4'b0100,
        RECOVER    = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // Sequential state and data logic with enable gating
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
            out_byte  <= 8'd0;
        end else begin
            state <= next_state;

            // Default done low, asserted only when valid stop bit detected
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift in LSB first: new bit enters MSB side
                    // Using shift right with MSB input to maintain previous logic
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt   <= bit_cnt + 3'd1;
                end

                CHECK_STOP: begin
                    bit_cnt <= 3'd0;
                    if (in == 1'b1) begin
                        // Stop bit correct: output data and pulse done
                        done <= 1'b1;
                        out_byte <= shift_reg;
                    end
                    // If stop bit wrong, no done, and recovery handled by FSM
                end

                RECOVER: begin
                    bit_cnt <= 3'd0;
                    // Hold shift_reg stable to avoid toggling
                    shift_reg <= shift_reg;
                end

                default: begin
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

    // Next-state logic combinational
    always @(*) begin
        // Default next state is current state
        next_state = state;

        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_cnt == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;    // Valid stop bit, go back to idle
                else
                    next_state = RECOVER; // Invalid stop bit, recover
            end

            RECOVER: begin
                if (in == 1'b1)
                    next_state = IDLE;    // Line back to idle state
                else
                    next_state = RECOVER; // Keep recovering
            end

            default: next_state = IDLE;
        endcase
    end

endmodule