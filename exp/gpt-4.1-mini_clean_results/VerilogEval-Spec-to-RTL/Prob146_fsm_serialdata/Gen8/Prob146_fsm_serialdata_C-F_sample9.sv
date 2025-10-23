module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding (2-bit binary)
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam STOP      = 2'b10;
    localparam WAIT_STOP = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;    // counts 0..7 data bits
    reg [7:0] data_shift;

    // Clock enable signals for registers
    wire receive_enable = (state == RECEIVE);

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter increments only in RECEIVE state; reset when detecting start bit in IDLE
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (state == IDLE && in == 1'b0)
            bit_count <= 3'd0;
        else if (receive_enable)
            bit_count <= bit_count + 3'd1;
    end

    // Shift register shifts in LSB first during RECEIVE; reset when start bit detected in IDLE
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == IDLE && in == 1'b0)
            data_shift <= 8'd0;
        else if (receive_enable)
            data_shift <= {in, data_shift[7:1]};
    end

    // done and out_byte update
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0; // default low each cycle
            if (state == STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;
            end
        end
    end

    // Combinational next state logic
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
                // After 8 data bits received, check stop bit
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                // Valid stop bit 1: ready for next byte
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    // Invalid stop bit: wait until line goes back to idle
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                // Wait for idle line before restarting
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule