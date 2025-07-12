module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding (binary)
    localparam [1:0]
        IDLE    = 2'b00,
        RECEIVE = 2'b01,
        STOP    = 2'b10;

    reg [1:0] state, next_state;
    reg [7:0] data_shift;
    reg [2:0] bit_count; // count 0..7

    // FSM state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter increments in RECEIVE state, reset on start bit detection
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (state == IDLE && in == 1'b0)
            bit_count <= 3'd0;
        else if (state == RECEIVE)
            bit_count <= bit_count + 3'd1;
    end

    // Data shift register, shifts right (LSB first)
    // Shift in new bit at MSB side each RECEIVE cycle
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == IDLE && in == 1'b0)
            data_shift <= 8'd0;
        else if (state == RECEIVE)
            data_shift <= {in, data_shift[7:1]};
    end

    // done signal asserted for one cycle on valid stop bit detection
    // out_byte latched on valid stop bit
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else if (state == STOP && in == 1'b1) begin
            done <= 1'b1;
            out_byte <= data_shift;
        end else
            done <= 1'b0;
    end

    // FSM next state logic combinational
    always @(*) begin
        next_state = state; // default hold state
        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After 8 bits received, go to STOP
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1) begin
                    // Valid stop bit, byte done
                    next_state = IDLE;
                end else begin
                    // Invalid stop bit: stay until line returns idle (high)
                    // Remain in STOP state waiting for line to go high
                    next_state = STOP;
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule