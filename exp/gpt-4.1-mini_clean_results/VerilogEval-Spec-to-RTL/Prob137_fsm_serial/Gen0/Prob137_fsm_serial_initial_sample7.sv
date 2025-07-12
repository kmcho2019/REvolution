module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    // States encoding
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam STOP_WAIT = 2'b10;

    reg [1:0] state, next_state;
    reg [3:0] bit_count;  // count 0 to 7 for data bits

    // Sequential logic for state and bit_count
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            done <= 0;
        end else begin
            state <= next_state;

            // default done = 0 unless set below
            done <= 0;

            case (state)
                IDLE: begin
                    bit_count <= 0;
                end
                RECEIVE: begin
                    if (bit_count < 8)
                        bit_count <= bit_count + 1;
                end
                STOP_WAIT: begin
                    // no bit count increment
                end
            endcase

            // done signal generation handled below to ensure one clock pulse
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                // wait for start bit = 0
                if (in == 0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 8) begin
                    // after receiving 8 data bits, check stop bit
                    if (in == 1)
                        next_state = IDLE; // correct stop bit, done will be set
                    else
                        next_state = STOP_WAIT; // incorrect stop bit, wait for stop bit
                end else begin
                    next_state = RECEIVE; // continue receiving data bits
                end
            end
            STOP_WAIT: begin
                if (in == 1)
                    next_state = IDLE;
                else
                    next_state = STOP_WAIT;
            end
        endcase
    end

    // done signal generation (one clock pulse when byte correctly received)
    // done is asserted only on the clock cycle when stop bit is confirmed correct
    always @(posedge clk) begin
        if (reset) begin
            done <= 0;
        end else begin
            if (state == RECEIVE && bit_count == 8 && in == 1) begin
                done <= 1;
            end else begin
                done <= 0;
            end
        end
    end

endmodule