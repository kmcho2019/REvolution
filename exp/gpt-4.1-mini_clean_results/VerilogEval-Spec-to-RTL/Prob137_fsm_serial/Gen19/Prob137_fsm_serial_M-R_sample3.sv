module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE  = 2'd0,
        DATA  = 2'd1,
        STOP  = 2'd2,
        ERROR = 2'd3
    } state_t;

    state_t state, next_state;

    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    // Next state logic and done signal generation
    always @* begin
        // Defaults
        next_state = state;
        done = 1'b0;

        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE;
            end

            DATA: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end

            STOP: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                    done = 1'b1;  // pulse done when stop bit is correct
                end else begin
                    next_state = ERROR;
                end
            end

            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, shift_reg, bit_count updates
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Update registers only in relevant states
            case (next_state)
                DATA: begin
                    // Shift in LSB first: shift_reg[6:0] shifted left, new bit in LSB
                    shift_reg <= {shift_reg[6:0], in};
                    bit_count <= bit_count + 1;
                end
                IDLE, STOP, ERROR: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
                default: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase

            // done signal assigned in combinational, latch to register here
            // (already assigned in combinational block, but assigned here for register output)
            // This done will pulse one cycle when stop bit correct
            // The combinational block sets done high only in STOP state with correct stop bit
            // So here, done is latched for one clock cycle
            // (Optional: done signal could be purely combinational if allowed)
        end
    end

endmodule