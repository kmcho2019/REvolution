module TopModule (
    input  wire        clk,
    input  wire        in,
    input  wire        reset,
    output reg [7:0]   out_byte,
    output reg         done
);

    // One-hot FSM encoding
    localparam IDLE = 3'b001,
               DATA = 3'b010,
               STOP = 3'b100;

    reg [2:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;
    reg error_flag;  // Indicates stop bit error waiting for valid stop

    // Sequential: State, counters, shift register, outputs
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            bit_cnt    <= 3'd0;
            shift_reg  <= 8'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
            error_flag <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                    done <= 1'b0;
                    error_flag <= 1'b0;
                end

                DATA: begin
                    // Shift right: MSB gets new bit, LSB shifted out.
                    // This shifts in LSB first bit on right side correctly.
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 1;
                    done <= 1'b0;
                    error_flag <= 1'b0;
                end

                STOP: begin
                    // done pulse on valid stop bit
                    if (in == 1'b1 && error_flag == 1'b0) begin
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        error_flag <= 1'b0;
                    end else begin
                        // No done, stay in error wait
                        done <= 1'b0;
                        if (in == 1'b1)
                            error_flag <= 1'b0; // Stop bit received, clear error
                        else
                            error_flag <= 1'b1; // Still waiting for stop bit
                    end
                    bit_cnt <= 3'd0;
                end

                default: begin
                    // Safety: reset outputs and state if invalid state encountered
                    state <= IDLE;
                    bit_cnt <= 3'd0;
                    shift_reg <= 8'd0;
                    out_byte <= 8'd0;
                    done <= 1'b0;
                    error_flag <= 1'b0;
                end
            endcase
        end
    end

    // Combinational: next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE;
            end

            DATA: begin
                // After receiving 8 bits, go to STOP to check stop bit
                if (bit_cnt == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end

            STOP: begin
                // If error_flag set, stay here until valid stop bit (in==1)
                if (error_flag)
                    next_state = STOP;
                else begin
                    if (in == 1'b1)
                        next_state = IDLE;
                    else
                        next_state = STOP; // wait for stop bit, error_flag set in sequential
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule