module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Optimized state encoding - only 2 states needed
    localparam IDLE    = 1'b0;
    localparam RECEIVE = 1'b1;

    reg state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg last_bit_received;  // Registered version of (bit_count == 7)

    // State transition and data processing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
            last_bit_received <= 0;
        end else begin
            state <= next_state;
            last_bit_received <= (bit_count == 7);

            // Optimized register updates
            case (state)
                IDLE: begin
                    bit_count <= 0;
                    done <= 0;
                end
                
                RECEIVE: begin
                    if (!last_bit_received) begin
                        shift_reg <= {in, shift_reg[7:1]};  // Right-shift for LSB-first
                        bit_count <= bit_count + 1;
                    end
                    done <= last_bit_received && in;  // Done when stop bit valid
                end
            endcase

            // Capture output byte when done
            if (last_bit_received && in && state == RECEIVE)
                out_byte <= shift_reg;
        end
    end

    // Optimized next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = (in == 0) ? RECEIVE : IDLE;
            RECEIVE: begin
                if (last_bit_received)
                    next_state = (in == 1) ? IDLE : RECEIVE;  // Wait for stop bit
                else
                    next_state = RECEIVE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule