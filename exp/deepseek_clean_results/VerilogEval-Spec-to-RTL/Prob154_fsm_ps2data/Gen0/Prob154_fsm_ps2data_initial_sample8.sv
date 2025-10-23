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

    // Message buffer
    reg [23:0] message_buffer;

    // FSM state transition
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            done <= 0;
            out_bytes <= 24'b0;
        end else begin
            current_state <= next_state;
            
            // Handle done signal (assert for one cycle only)
            done <= (current_state == BYTE3);
            
            // Capture output when we have all 3 bytes
            if (current_state == BYTE3) begin
                out_bytes <= message_buffer;
            end
        end
    end

    // FSM next state logic and message buffering
    always_comb begin
        next_state = current_state;
        
        case (current_state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE2;
                end
            end
            
            BYTE2: begin
                next_state = BYTE3;
            end
            
            BYTE3: begin
                next_state = IDLE;
            end
        endcase
    end

    // Message buffering logic
    always_ff @(posedge clk) begin
        if (reset) begin
            message_buffer <= 24'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    if (in[3]) begin
                        message_buffer[23:16] <= in;
                    end
                end
                
                BYTE2: begin
                    message_buffer[15:8] <= in;
                end
                
                BYTE3: begin
                    message_buffer[7:0] <= in;
                end
            endcase
        end
    end

endmodule