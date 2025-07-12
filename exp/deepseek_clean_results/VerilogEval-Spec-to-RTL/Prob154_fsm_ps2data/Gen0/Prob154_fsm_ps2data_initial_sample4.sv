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

    // Byte storage registers
    reg [7:0] byte1, byte2, byte3;

    // FSM state transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            out_bytes <= 24'b0;
            done <= 0;
        end else begin
            current_state <= next_state;
            
            // Default outputs
            done <= 0;
            
            // State actions
            case (current_state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                    end
                end
                
                BYTE2: begin
                    byte2 <= in;
                end
                
                BYTE3: begin
                    byte3 <= in;
                    out_bytes <= {byte1, byte2, in};
                    done <= 1;
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