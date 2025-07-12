module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Define states
    typedef enum logic [1:0] {
        IDLE,
        RECEIVE,
        STOP,
        ERROR
    } state_t;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    bit_count <= 0;
                    done <= 0;
                    if (in == 0) begin
                        shift_reg <= 0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // Shift right (LSB first)
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    out_byte <= shift_reg;
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
        case (state)
            IDLE:
                next_state = (in == 0) ? RECEIVE : IDLE;
            
            RECEIVE:
                next_state = (bit_count == 3'b111) ? STOP : RECEIVE;
            
            STOP:
                next_state = (in == 1) ? IDLE : ERROR;
            
            ERROR:
                next_state = (in == 1) ? IDLE : ERROR;
            
            default:
                next_state = IDLE;
        endcase
    end

endmodule