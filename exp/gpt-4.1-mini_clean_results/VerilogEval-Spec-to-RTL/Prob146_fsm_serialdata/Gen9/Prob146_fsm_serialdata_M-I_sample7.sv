module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot state encoding
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam STOP_CHECK = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;      // 3-bit counter for 8 data bits
    reg [7:0] shift_reg;

    wire shift_enable  = (state == RECEIVE);
    wire count_enable  = (state == RECEIVE);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter with enable
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (count_enable)
            bit_count <= bit_count + 3'd1;
        else if (state == IDLE || state == STOP_CHECK || state == WAIT_STOP)
            bit_count <= 3'd0;
    end

    // Shift register with enable, shift left inserting LSB-first bit on right
    // shift_reg[0] is LSB, so shift left and insert new bit at LSB
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (shift_enable)
            shift_reg <= {in, shift_reg[7:1]};  // LSB first: new bit enters MSB, shift right
        else if (state == IDLE)
            shift_reg <= 8'd0;
    end

    // Output done and out_byte logic
    // done pulses high only on valid stop bit detection
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0; // default no done
            if (state == STOP_CHECK && in == 1'b1) begin
                done <= 1'b1;
                out_byte <= shift_reg;
            end
        end
    end

    // Next state logic using one-hot encoding
    always @(*) begin
        // Default next state hold
        next_state = state;

        case (1'b1)  // priority encoding style for one-hot FSM
            state[0]: begin // IDLE
                if (in == 1'b0)  // start bit detected
                    next_state = RECEIVE;
            end

            state[1]: begin // RECEIVE
                if (bit_count == 3'd7)
                    next_state = STOP_CHECK;
            end

            state[2]: begin // STOP_CHECK
                if (in == 1'b1)
                    next_state = IDLE;       // Valid stop bit, ready for next
                else
                    next_state = WAIT_STOP;  // Invalid stop bit, wait for idle
            end

            state[3]: begin // WAIT_STOP
                if (in == 1'b1)
                    next_state = IDLE;       // Line idle regained
            end

            default: next_state = IDLE;
        endcase
    end

endmodule