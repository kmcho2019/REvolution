module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    localparam [1:0] 
        IDLE   = 2'b00,
        RECEIVE = 2'b01,
        STOP   = 2'b10;

    reg [1:0] current_state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // State transition logic (combinational)
    always @(*) begin
        case (current_state)
            IDLE: next_state = (in == 0) ? RECEIVE : IDLE;
            
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end
            
            STOP: next_state = (in == 1) ? IDLE : STOP;
            
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic (state and registers)
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            current_state <= next_state;
            
            case (current_state)
                IDLE: begin
                    bit_count <= 0;
                    done <= 0;
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // LSB first
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    if (in == 1) begin  // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1;
                    end else begin
                        done <= 0;
                    end
                end
            endcase
        end
    end

endmodule