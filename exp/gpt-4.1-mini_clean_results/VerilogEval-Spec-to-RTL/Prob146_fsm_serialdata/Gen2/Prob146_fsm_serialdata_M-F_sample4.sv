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
    reg [2:0] bit_count;      // counts from 0 to 7 for data bits
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
            done <= 1'b0;  // default done low each clock

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_shift <= 8'd0;
                    // Wait for start bit detected via next_state logic
                end
                RECEIVING: begin
                    // Shift left, new bit into LSB for LSB first reception
                    data_shift <= {data_shift[6:0], in};
                    bit_count <= bit_count + 1'b1;
                end
                WAIT_STOP: begin
                    // Hold data and counters cleared until stop bit found
                    bit_count <= 3'd0;
                    data_shift <= 8'd0;
                end
            endcase

            // On receiving 8 data bits, check stop bit in input 'in'
            if (state == RECEIVING && bit_count == 3'd8) begin
                if (in == 1'b1) begin
                    // Valid stop bit detected, output byte and assert done
                    out_byte <= data_shift;
                    done <= 1'b1;
                end
                // else done remains 0, next_state logic handles WAIT_STOP
            end
        end
    end

    // Next state combinational logic
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
                    if (in == 1'b1)  // stop bit valid
                        next_state = IDLE;
                    else
                        next_state = WAIT_STOP;
                end else begin
                    next_state = RECEIVING;
                end
            end
            WAIT_STOP: begin
                if (in == 1'b1)  // stop bit found
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule