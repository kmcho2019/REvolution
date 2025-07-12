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
    reg [2:0] bit_count; // counts 0 to 7
    reg [7:0] data_shift;

    // Sequential logic with clock enables
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            // State always updates
            state <= next_state;

            // Default done low
            done <= 1'b0;

            // Reset bit_count and data_shift only at start bit detection in IDLE
            if (state == IDLE && in == 1'b0)
            begin
                bit_count <= 3'd0;
                data_shift <= 8'd0;
            end

            // Shift in data and increment count only in RECEIVE
            if (state == RECEIVE)
            begin
                data_shift <= {in, data_shift[7:1]}; // LSB first
                bit_count <= bit_count + 1;
            end

            // In STOP state, if stop bit is correct, output data and assert done
            if (state == STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;
            end

            // No updates to bit_count or data_shift in WAIT_STOP or elsewhere
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;  // start bit detected
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
                    next_state = IDLE;  // valid stop bit, ready for next byte
                else
                    next_state = WAIT_STOP; // invalid stop bit, wait for line to idle
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