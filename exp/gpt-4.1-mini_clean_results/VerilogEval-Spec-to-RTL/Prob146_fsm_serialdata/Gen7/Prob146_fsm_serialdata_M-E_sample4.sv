module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot state encoding
    localparam IDLE        = 4'b0001;
    localparam START_WAIT  = 4'b0010;
    localparam DATA        = 4'b0100;
    localparam STOP_VERIFY = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_index;      // counts 0 to 7 for data bits
    reg [7:0] data_shift;

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter updates only in DATA state
    always @(posedge clk) begin
        if (reset)
            bit_index <= 3'd0;
        else if (state == IDLE)
            bit_index <= 3'd0;
        else if (state == DATA)
            bit_index <= bit_index + 3'd1;
    end

    // Shift register shifts in data bits LSB first during DATA state
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == IDLE)
            data_shift <= 8'd0;
        else if (state == DATA)
            data_shift <= {in, data_shift[7:1]};
    end

    // Output and done register: done pulse asserted when stop bit detected as valid
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // default no done
            if (state == STOP_VERIFY && in == 1'b1)
                begin
                    out_byte <= data_shift;
                    done <= 1'b1;
                end
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = IDLE; // default

        case(state)
            IDLE: begin
                // Wait for start bit (in == 0)
                if (in == 1'b0)
                    next_state = START_WAIT;
                else
                    next_state = IDLE;
            end

            START_WAIT: begin
                // Sample start bit again to confirm it's still low (simple debounce)
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE;  // False start, go back idle
            end

            DATA: begin
                // After 8 bits received, move to stop bit verification
                if (bit_index == 3'd7)
                    next_state = STOP_VERIFY;
                else
                    next_state = DATA;
            end

            STOP_VERIFY: begin
                if (in == 1'b1)
                    next_state = IDLE;      // valid stop bit, ready for next byte
                else
                    next_state = STOP_VERIFY; // wait until line goes high to sync back to IDLE
            end

            default: next_state = IDLE;
        endcase
    end

endmodule