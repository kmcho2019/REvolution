module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    typedef enum reg [1:0] {IDLE=2'd0, RECEIVE=2'd1, STOP_BIT=2'd2, RECOVER=2'd3} state_t;
    state_t state, next_state;

    reg [2:0] bit_cnt;        // Counts received data bits 0-7
    reg [7:0] data_reg;       // Shift register for data bits

    // Sequential state register and output logic
    always @(posedge clk) begin
        if (reset) begin
            state    <= IDLE;
            bit_cnt  <= 3'd0;
            data_reg <= 8'd0;
            done     <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0;  // Default done low; pulses for 1 cycle on valid byte
            case(state)
                IDLE: begin
                    bit_cnt  <= 3'd0;
                    data_reg <= 8'd0;
                end
                RECEIVE: begin
                    data_reg <= {in, data_reg[7:1]};  // Shift right; LSB first input
                    bit_cnt  <= bit_cnt + 1'b1;
                end
                STOP_BIT: begin
                    // done signal generated combinationally below in next_state logic
                end
                RECOVER: begin
                    // Wait until in == 1, no registers updated
                end
            endcase
        end
    end

    // Combinational next-state and done signal generation
    always @(*) begin
        next_state = state;
        done = 1'b0;
        case(state)
            IDLE: begin
                // Wait for start bit = 0
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP_BIT;
                else
                    next_state = RECEIVE;
            end
            STOP_BIT: begin
                if (in == 1'b1) begin
                    done = 1'b1;
                    next_state = IDLE;
                end else
                    next_state = RECOVER;
            end
            RECOVER: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule