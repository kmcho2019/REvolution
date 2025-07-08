module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // State encoding
    localparam IDLE     = 3'd0;
    localparam START    = 3'd1;
    localparam DATA     = 3'd2;
    localparam STOP     = 3'd3;
    localparam WAIT_STOP= 3'd4;

    reg [2:0] state, next_state;
    reg [2:0] bit_count;  // 3 bits to count to 8
    reg [7:0] data_reg;

    // Sequential state register and counters
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no done, assert only on STOP correct

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_reg <= 8'd0;
                end
                START: begin
                    // No count change here
                    data_reg <= 8'd0;
                    bit_count <= 3'd0;
                end
                DATA: begin
                    // Shift in data bit LSB first
                    // data_reg[0] gets first bit, then next bits are shifted in higher bits
                    // Use bit_count as index to shift
                    // Shift left and insert new bit at LSB
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 3'd1;
                end
                STOP: begin
                    // no update of data_reg or bit_count here
                end
                WAIT_STOP: begin
                    // wait until input line goes 1
                end
                default: ;
            endcase
        end
    end

    // Next state and done signal logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                // line idle is 1; waiting for start bit = 0
                if (in == 1'b0) begin
                    next_state = START;
                end
            end
            START: begin
                // Confirm start bit is still 0 on next clock
                // In case line noise or glitch, check input again
                if (in == 1'b0) begin
                    next_state = DATA;
                end else begin
                    next_state = IDLE; // false start bit, back to idle
                end
            end
            DATA: begin
                if (bit_count == 3'd7) begin
                    // After receiving 8 data bits, move to STOP to check stop bit next
                    next_state = STOP;
                end else begin
                    next_state = DATA;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    // Correct stop bit, done signal asserted for 1 clock cycle
                    next_state = IDLE;
                end else begin
                    // Stop bit incorrect, must wait for stop bit = 1 before restarting
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

    // done asserted only on STOP state if stop bit correct
    always @(posedge clk) begin
        if (!reset && state == STOP && in == 1'b1) begin
            done <= 1'b1;
        end
    end

endmodule