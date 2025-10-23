module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam RECEIVING = 2'd1;
    localparam WAIT_STOP = 2'd2;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;      // count 0 to 7 for 8 bits
    reg [7:0] data_shift;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low each cycle

            case(state)
                IDLE: begin
                    if (in == 1'b0) begin  // start bit detected
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end
                RECEIVING: begin
                    // Shift in LSB first: shift right, new bit into MSB
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1'b1;
                end
                WAIT_STOP: begin
                    // no data or counters updated here
                end
            endcase

            // Check stop bit and output data + done in RECEIVING state after 8 bits
            if (state == RECEIVING && bit_count == 3'd8) begin
                if (in == 1'b1) begin
                    out_byte <= data_shift;
                    done <= 1'b1;
                end
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in == 1'b0)  // start bit detected
                    next_state = RECEIVING;
                else
                    next_state = IDLE;
            end
            RECEIVING: begin
                if (bit_count == 3'd8) begin
                    if (in == 1'b1)  // stop bit correct
                        next_state = IDLE;
                    else
                        next_state = WAIT_STOP;
                end else begin
                    next_state = RECEIVING;
                end
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