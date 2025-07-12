module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    localparam IDLE   = 1'b0;
    localparam RECEIVE = 1'b1;

    reg state, next_state;
    reg [3:0] bit_count;  // Counts 0-8 (0-7 for data, 8 for stop)

    // FSM state transition and data processing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            done <= 0;

            case (state)
                IDLE: begin
                    bit_count <= 0;
                    if (in == 0) begin  // Start bit detected
                        out_byte <= 0;
                    end
                end

                RECEIVE: begin
                    if (bit_count < 8) begin
                        out_byte <= {in, out_byte[7:1]};  // Shift in LSB first
                        bit_count <= bit_count + 1;
                    end
                    else if (in) begin  // Stop bit verified
                        done <= 1;
                        bit_count <= 0;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (in == 0) ? RECEIVE : IDLE;
            RECEIVE: begin
                if (bit_count == 8 && in == 1)  // Complete byte received
                    next_state = IDLE;
                else
                    next_state = RECEIVE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule