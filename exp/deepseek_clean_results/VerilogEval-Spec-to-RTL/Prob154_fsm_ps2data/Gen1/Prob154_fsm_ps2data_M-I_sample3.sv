module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE,
        BYTE1,
        BYTE2
    } state_t;

    reg [1:0] state, next_state;
    reg [7:0] byte1, byte2;  // Storage for first two bytes

    // FSM state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            byte1 <= 0;
            byte2 <= 0;
            out_bytes <= 0;
        end else begin
            state <= next_state;
            
            // Default done to 0 unless we're completing a message
            done <= 0;
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;  // Store first byte
                    end
                end
                
                BYTE1: begin
                    byte2 <= in;     // Store second byte
                end
                
                BYTE2: begin
                    // On third byte, output message and assert done
                    out_bytes <= {byte1, byte2, in};
                    done <= 1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = in[3] ? BYTE1 : IDLE;
            end
            
            BYTE1: begin
                next_state = BYTE2;
            end
            
            BYTE2: begin
                next_state = IDLE;  // Always return to IDLE after 3 bytes
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule