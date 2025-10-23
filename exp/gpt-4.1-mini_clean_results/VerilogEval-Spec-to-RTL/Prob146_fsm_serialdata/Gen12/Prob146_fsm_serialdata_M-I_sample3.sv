module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // Binary encoded FSM states (2 bits)
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam STOP      = 2'b10;
    localparam WAIT_STOP = 2'b11;

    reg [1:0] state, next_state;

    reg [7:0] data_shift;
    reg [2:0] bit_count;

    wire receive_enable = (state == RECEIVE);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter with clock enable, reset on start bit detection
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (receive_enable)
            bit_count <= bit_count + 3'd1;
        else if (state == IDLE && in == 1'b0)
            bit_count <= 3'd0;
    end

    // Shift register for serial data, shift right to place new bit at MSB
    // Serial protocol sends LSB first, so shifting right inserts new bit at MSB
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == IDLE && in == 1'b0)
            data_shift <= 8'd0;
        else if (receive_enable)
            data_shift <= {in, data_shift[7:1]};
    end

    // done signal and output byte logic
    // done asserted one cycle when a valid stop bit detected
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0; // default done low each cycle
            if (state == STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = IDLE; // default to IDLE

        case(state)
            IDLE: begin
                if (in == 1'b0)       // start bit detected
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
                if (in == 1'b1)      // valid stop bit
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                if (in == 1'b1)      // wait until line idle again
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule