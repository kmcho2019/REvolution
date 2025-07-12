module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // States
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam WAIT_STOP = 2'd2;

    reg [1:0] state, next_state;

    reg [3:0] bit_count;    // 0 to 7 for 8 bits
    reg [7:0] data_shift;

    // To implement bit-center sampling assuming clk = bit period,
    // add a sample_enable flag that delays sampling data bits until one clock after start bit detection.
    reg sample_enable;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
            sample_enable <= 1'b0;
        end else begin
            done <= 1'b0; // default done low

            state <= next_state;

            case(state)
                IDLE: begin
                    // Reset counters and flags on idle
                    bit_count <= 4'd0;
                    data_shift <= 8'd0;
                    sample_enable <= 1'b0;
                end
                RECEIVE: begin
                    if (!sample_enable) begin
                        // This cycle after start bit detection: enable sampling next clock
                        sample_enable <= 1'b1;
                    end else begin
                        // Sample data bit at bit center: shift LSB first
                        data_shift <= {in, data_shift[7:1]}; 
                        bit_count <= bit_count + 1'b1;
                    end
                end
                WAIT_STOP: begin
                    // Keep clearing counters and disable sampling while waiting for stop bit
                    bit_count <= 4'd0;
                    data_shift <= 8'd0;
                    sample_enable <= 1'b0;
                end
            endcase

            // When 8 bits have been sampled (bit_count==8), check stop bit 'in' and assert done accordingly
            if (state == RECEIVE && sample_enable && bit_count == 4'd8) begin
                if (in == 1'b1) begin
                    // Valid stop bit
                    out_byte <= data_shift;
                    done <= 1'b1;
                end
                // else wait_stop state entered via next_state logic
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                // Detect start bit: line goes low
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                // If 8 bits sampled and sampling enabled, check stop bit
                if (sample_enable && bit_count == 4'd8) begin
                    if (in == 1'b1)
                        next_state = IDLE;        // valid stop bit, go idle
                    else
                        next_state = WAIT_STOP;   // framing error, wait for stop
                end else begin
                    next_state = RECEIVE;
                end
            end
            WAIT_STOP: begin
                // Wait until line returns to idle (1) before starting new frame
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule