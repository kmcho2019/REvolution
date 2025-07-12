module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot state encoding
    localparam IDLE      = 4'b0001;
    localparam RECEIVE   = 4'b0010;
    localparam STOP      = 4'b0100;
    localparam WAIT_STOP = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;      // 3 bits to count 8 data bits (0 to 7)
    reg [7:0] data_shift;

    wire shift_enable = (state == RECEIVE);
    wire count_enable = (state == RECEIVE);

    // Sequential logic: state, bit_count, data_shift, outputs
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            bit_count  <= 3'd0;
            data_shift <= 8'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0;  // Default done low each cycle

            // Shift register and counter update only when enabled to save power
            if (shift_enable) begin
                // Shift in LSB first: shift right and insert new bit at MSB
                data_shift <= {in, data_shift[7:1]};
            end

            if (count_enable) begin
                bit_count <= bit_count + 1'b1;
            end else if (state == IDLE) begin
                bit_count <= 3'd0; // reset count when idle
                data_shift <= 8'd0; // reset data_shift when idle
            end

            // Output and done assertion during STOP state
            if (state == STOP) begin
                if (in == 1'b1) begin
                    out_byte <= data_shift;
                    done <= 1'b1;
                end
            end
        end
    end

    // Combinational next-state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            IDLE: begin
                if (in == 1'b0)  // Start bit detected (line goes low)
                    next_state = RECEIVE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP; // Received 8 bits
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;     // Valid stop bit: back to idle
                else
                    next_state = WAIT_STOP; // Wait for valid stop bit
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;    // Stop bit line idle again, ready for next byte
            end

            default: next_state = IDLE;
        endcase
    end

endmodule