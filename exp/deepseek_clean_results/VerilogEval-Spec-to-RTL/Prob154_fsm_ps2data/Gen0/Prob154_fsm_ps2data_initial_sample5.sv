module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Define states
    typedef enum logic [1:0] {
        IDLE,
        BYTE2,
        BYTE3
    } state_t;

    // State registers
    state_t current_state, next_state;

    // Shift register to store message bytes
    reg [23:0] byte_shift_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            byte_shift_reg <= 24'b0;
            done <= 0;
        end else begin
            current_state <= next_state;
            
            case (current_state)
                IDLE: begin
                    if (in[3]) begin
                        byte_shift_reg[23:16] <= in;
                        done <= 0;
                    end
                end
                BYTE2: begin
                    byte_shift_reg[15:8] <= in;
                    done <= 0;
                end
                BYTE3: begin
                    byte_shift_reg[7:0] <= in;
                    out_bytes <= {byte_shift_reg[23:16], byte_shift_reg[15:8], in};
                    done <= 1;
                end
                default: begin
                    done <= 0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                next_state = (in[3]) ? BYTE2 : IDLE;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule