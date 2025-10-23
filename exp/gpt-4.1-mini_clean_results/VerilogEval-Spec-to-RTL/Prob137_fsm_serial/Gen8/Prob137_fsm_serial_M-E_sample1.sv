module TopModule (
    input wire clk,
    input wire reset,
    input wire in,
    output reg done
);

    // State encoding
    localparam [1:0]
        IDLE      = 2'b00,
        RECEIVE   = 2'b01,
        WAIT_STOP = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count; // counts from 0 to 7 for 8 bits received

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)       // Detect start bit
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = WAIT_STOP;
                else
                    next_state = RECEIVE;
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

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;  // default done low

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    // Wait for start bit
                end
                RECEIVE: begin
                    bit_count <= bit_count + 1'b1;
                end
                WAIT_STOP: begin
                    if (in == 1'b1) begin
                        done <= 1'b1; // Successfully received a full byte
                        bit_count <= 3'd0;
                    end
                end
            endcase
        end
    end

endmodule