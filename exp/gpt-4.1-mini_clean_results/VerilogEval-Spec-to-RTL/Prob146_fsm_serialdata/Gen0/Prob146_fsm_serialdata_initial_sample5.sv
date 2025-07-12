module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    localparam IDLE      = 3'd0;
    localparam START     = 3'd1;
    localparam DATA      = 3'd2;
    localparam STOP      = 3'd3;
    localparam WAIT_STOP = 3'd4;

    reg [2:0] state, next_state;
    reg [2:0] bit_cnt;     // counts bits received (0 to 7)
    reg [7:0] data_reg;    // stores received data bits

    // Sequential logic for state and registers
    always @(posedge clk) begin
        if (reset) begin
            state    <= IDLE;
            bit_cnt  <= 3'd0;
            data_reg <= 8'd0;
            out_byte <= 8'd0;
            done     <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low, asserted only for one clock cycle

            case (state)
                IDLE: begin
                    // wait for start bit 0
                    // nothing else to update
                end
                START: begin
                    // No extra clock needed here, we move to DATA in next cycle
                    bit_cnt <= 3'd0;
                    data_reg <= 8'd0;
                end
                DATA: begin
                    // Shift in LSB first, so we place bit in position bit_cnt
                    data_reg[bit_cnt] <= in;
                    bit_cnt <= bit_cnt + 1'b1;
                end
                STOP: begin
                    // Nothing to shift here
                end
                WAIT_STOP: begin
                    // Wait until in==1 for stop bit before restarting reception
                end
                default: ;
            endcase

            // Update out_byte and done on valid stop bit detection
            if (state == STOP && in == 1'b1) begin
                out_byte <= data_reg;
                done <= 1'b1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;
                else
                    next_state = IDLE;
            end
            START: begin
                // Move immediately to DATA on next clock
                next_state = DATA;
            end
            DATA: begin
                if (bit_cnt == 3'd7) begin
                    next_state = STOP;
                end else begin
                    next_state = DATA;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    // valid stop bit detected, go back to IDLE for next byte
                    next_state = IDLE;
                end else begin
                    // stop bit invalid, wait for line to go to 1 before next start
                    next_state = WAIT_STOP;
                end
            end
            WAIT_STOP: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_STOP;
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule