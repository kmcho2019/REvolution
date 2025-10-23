module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    // Define states
    typedef enum logic [2:0] {
        IDLE,
        RECEIVE,
        STOP,
        DONE,
        ERROR
    } state_t;

    reg [2:0] state, next_state;
    reg [3:0] bit_count;  // Need to count up to 8 (0-7)
    reg [7:0] shift_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    bit_count <= 0;
                    shift_reg <= 0;
                    done <= 0;
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // LSB first
                    bit_count <= bit_count + 1;
                    done <= 0;
                end
                
                STOP: begin
                    done <= 0;
                end
                
                DONE: begin
                    done <= 1;
                end
                
                ERROR: begin
                    done <= 0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        
        case (state)
            IDLE: begin
                if (!in) next_state = RECEIVE;  // Start bit detected
            end
            
            RECEIVE: begin
                if (bit_count == 3'd7) next_state = STOP;  // Received all 8 bits
            end
            
            STOP: begin
                if (in) next_state = DONE;     // Valid stop bit
                else next_state = ERROR;       // Missing stop bit
            end
            
            DONE: begin
                next_state = IDLE;
            end
            
            ERROR: begin
                if (in) next_state = IDLE;     // Found stop bit, return to IDLE
            end
        endcase
    end

endmodule