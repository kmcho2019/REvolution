module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    localparam IDLE = 2'd0;
    localparam DATA = 2'd1;
    localparam STOP = 2'd2;
    localparam WAIT_STOP = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;  // 0 to 7 for data bits
    reg [7:0] data_shift;

    // State register and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // Default done to 0 each cycle unless set

            case(state)
                IDLE: begin
                    if (in == 1'b0) begin // start bit detected
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end
                DATA: begin
                    // Shift in the bit (LSB first)
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1'b1;
                end
                STOP: begin
                    if (in == 1'b1) begin
                        // Valid stop bit
                        out_byte <= data_shift;
                        done <= 1'b1;
                    end
                end
                WAIT_STOP: begin
                    // Wait for stop bit (1) before going to IDLE
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = DATA;
                else
                    next_state = IDLE;
            end
            DATA: begin
                if (bit_count == 3'd7) // last data bit received
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
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