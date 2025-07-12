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
        BYTE1,
        BYTE2,
        DONE
    } state_t;

    // State registers
    state_t current_state, next_state;

    // Shift register for storing bytes
    reg [23:0] byte_shift_reg;

    // State transition logic
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            byte_shift_reg <= 24'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            current_state <= next_state;
            
            case (current_state)
                IDLE: begin
                    if (in[3]) begin
                        byte_shift_reg[23:16] <= in;
                    end
                    done <= 1'b0;
                end
                
                BYTE1: begin
                    byte_shift_reg[15:8] <= in;
                end
                
                BYTE2: begin
                    byte_shift_reg[7:0] <= in;
                end
                
                DONE: begin
                    out_bytes <= byte_shift_reg;
                    done <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            IDLE: begin
                next_state = in[3] ? BYTE1 : IDLE;
            end
            
            BYTE1: begin
                next_state = BYTE2;
            end
            
            BYTE2: begin
                next_state = DONE;
            end
            
            DONE: begin
                next_state = IDLE;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule