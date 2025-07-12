module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    localparam IDLE = 2'd0;
    localparam DATA = 2'd1;
    localparam STOP = 2'd2;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;  // Default done low every cycle unless set below

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_shift <= 8'd0;
                    // Wait for start bit (in == 0)
                end

                DATA: begin
                    // Shift in new bit LSB first: oldest bits shift up, new bit goes to LSB
                    data_shift <= {data_shift[6:0], in};
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    // Assert done only if stop bit (in) == 1 (valid stop bit)
                    if (in == 1'b1)
                        done <= 1'b1;
                    // else keep done = 0 and remain in STOP waiting for valid stop bit
                end

                default: begin
                    bit_count <= 3'd0;
                    data_shift <= 8'd0;
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE;
            end

            DATA: begin
                // After receiving 8 bits (bit_count from 0 to 7), move to STOP state
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule