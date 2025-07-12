module TopModule (
    input  clk,
    input  in,
    input  reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam STOP      = 2'd2;
    localparam WAIT_STOP = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;    // counts 0..7 data bits
    reg [7:0] data_shift;

    // Sequential logic with clock enables for efficient toggling
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            bit_count  <= 3'd0;
            data_shift <= 8'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low every cycle; assert only on valid stop bit in STOP state
            done <= 1'b0;

            // Reset bit_count and data_shift only when start bit detected in IDLE
            if (state == IDLE && in == 1'b0) begin
                bit_count  <= 3'd0;
                data_shift <= 8'd0;
            end

            // Shift data bits in RECEIVE state (LSB first)
            if (state == RECEIVE) begin
                data_shift <= {in, data_shift[7:1]};
                bit_count  <= bit_count + 1;
            end

            // On valid stop bit in STOP state, output received byte and assert done
            if (state == STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done     <= 1'b1;
            end

            // In WAIT_STOP state or elsewhere, no changes to bit_count or data_shift
        end
    end

    // Combinational next-state logic for clarity and timing optimization
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After receiving 8 bits, check stop bit next
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                // If stop bit valid (1), go back to IDLE for next byte
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    // Invalid stop bit, wait until line goes back to 1 (stop bit)
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                // Wait for line to return to idle (1) before next byte
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule