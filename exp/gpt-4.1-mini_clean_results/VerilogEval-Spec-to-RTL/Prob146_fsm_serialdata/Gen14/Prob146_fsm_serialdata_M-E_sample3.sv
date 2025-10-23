module TopModule (
    input  wire        clk,
    input  wire        in,
    input  wire        reset,
    output reg  [7:0]  out_byte,
    output wire        done
);

    // One-hot state encoding
    localparam IDLE      = 5'b00001,
               START     = 5'b00010,
               DATA      = 5'b00100,
               STOP      = 5'b01000,
               WAIT_STOP = 5'b10000;

    reg [4:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] data_shift;
    reg       bit_cnt_en;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter with enable
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (bit_cnt_en)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= 3'd0;
    end

    // Shift register: shift in 'in' LSB first during DATA state only
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == DATA)
            data_shift <= {in, data_shift[7:1]};
        else if (state == IDLE)
            data_shift <= 8'd0;
    end

    // Next state logic
    always @(*) begin
        // default assignments
        next_state = state;
        bit_cnt_en = 1'b0;

        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;  // detected start bit low
                else
                    next_state = IDLE;
            end
            START: begin
                // Confirm start bit low sampled one clock after detecting start bit
                if (in == 1'b0)
                    next_state = DATA;   // valid start bit confirmed
                else
                    next_state = IDLE;   // false start bit, return idle
            end
            DATA: begin
                bit_cnt_en = 1'b1;
                if (bit_cnt == 3'd7)
                    next_state = STOP;   // after 8 bits, go to stop bit check
                else
                    next_state = DATA;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;   // valid stop bit, back to idle for next byte
                else
                    next_state = WAIT_STOP; // invalid stop bit, wait for idle line
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;   // line back to idle, can start over
                else
                    next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic (Mealy done signal)
    assign done = (state == STOP) && (in == 1'b1);

    // Register the output byte at the STOP state when stop bit is valid (Mealy to registered out_byte)
    always @(posedge clk) begin
        if (reset)
            out_byte <= 8'd0;
        else if (done)
            out_byte <= data_shift;
    end

endmodule