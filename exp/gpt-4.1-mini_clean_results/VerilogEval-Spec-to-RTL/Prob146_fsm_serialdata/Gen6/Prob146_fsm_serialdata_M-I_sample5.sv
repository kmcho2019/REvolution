module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam STOP      = 2'd2;
    localparam WAIT_STOP = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count; // to count 8 bits (0 to 7)
    reg [7:0] data_shift;

    // Sequential logic with clock enables for registers to reduce toggling
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Default no done signal
            done <= 1'b0;

            // Update bit_count and data_shift only in RECEIVE state
            if (state == RECEIVE) begin
                // Shift in LSB first
                data_shift <= {in, data_shift[7:1]};
                bit_count <= bit_count + 1;
            end

            // Reset bit_count and data_shift when start bit detected at IDLE
            else if (state == IDLE && in == 1'b0) begin
                bit_count <= 3'd0;
                data_shift <= 8'd0;
            end

            // Update out_byte and done only on correct stop bit in STOP state
            if (state == STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;
            end
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;  // good stop bit, ready for next byte
                else
                    next_state = WAIT_STOP; // bad stop bit
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule