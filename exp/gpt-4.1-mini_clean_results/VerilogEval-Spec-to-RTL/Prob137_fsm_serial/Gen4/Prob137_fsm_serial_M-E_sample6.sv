module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot state encoding
    localparam IDLE       = 5'b00001;
    localparam START      = 5'b00010;
    localparam DATA_BITS  = 5'b00100;
    localparam STOP_CHECK = 5'b01000;
    localparam ERROR_WAIT = 5'b10000;

    reg [4:0] state, next_state;

    reg [2:0] bit_count;       // Count 0..7 data bits
    reg [7:0] data_shift;      // For completeness, though data is not output

    // Sequential logic: state, bit_count, data_shift, done
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;  // default no pulse

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_shift <= 8'd0;
                end

                START: begin
                    // Wait one clock to confirm start bit low, no actions here
                end

                DATA_BITS: begin
                    // Shift in LSB first
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 3'd1;
                end

                STOP_CHECK: begin
                    // done asserted if stop bit is 1
                    if (in == 1'b1)
                        done <= 1'b1;
                end

                ERROR_WAIT: begin
                    // Wait until line goes idle (1)
                    bit_count <= 3'd0;
                    data_shift <= 8'd0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;

        case(state)
            IDLE: begin
                if (in == 1'b0)       // Detect start bit low
                    next_state = START;
            end

            START: begin
                // Confirm start bit still low at next clock
                if (in == 1'b0)
                    next_state = DATA_BITS;
                else
                    next_state = IDLE;  // False start bit glitch, go back
            end

            DATA_BITS: begin
                if (bit_count == 3'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = DATA_BITS;
            end

            STOP_CHECK: begin
                if (in == 1'b1)
                    next_state = IDLE;       // Valid stop bit
                else
                    next_state = ERROR_WAIT; // Invalid stop bit, wait for idle
            end

            ERROR_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE;       // Wait for line to return idle
            end

            default: next_state = IDLE;
        endcase
    end

endmodule