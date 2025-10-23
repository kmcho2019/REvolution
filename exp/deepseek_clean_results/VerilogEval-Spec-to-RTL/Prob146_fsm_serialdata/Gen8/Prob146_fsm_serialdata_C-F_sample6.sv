module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states - 2-bit encoding for area efficiency
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam ERROR   = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // State transition and data processing
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
                        shift_reg <= 0;  // Prepare for new reception
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // Efficient right-shift for LSB-first
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    if (in == 1) begin
                        out_byte <= shift_reg;
                        done <= 1;  // Assert done only when stop bit is valid
                    end else begin
                        done <= 0;
                    end
                end
                
                ERROR: begin
                    done <= 0;  // Simple error state with minimal logic
                end
            endcase
        end
    end

    // Next state logic - optimized from both examples
    always @(*) begin
        case (state)
            IDLE:    next_state = (in == 0) ? RECEIVE : IDLE;
            RECEIVE:  next_state = (bit_count == 7) ? STOP : RECEIVE;
            STOP:    next_state = (in == 1) ? IDLE : ERROR;
            ERROR:   next_state = (in == 1) ? IDLE : ERROR;
            default: next_state = IDLE;
        endcase
    end

endmodule