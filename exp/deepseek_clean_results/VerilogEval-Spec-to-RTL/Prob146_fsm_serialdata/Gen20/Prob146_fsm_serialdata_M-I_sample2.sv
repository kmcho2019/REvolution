module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states - optimized 2-bit encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam WAIT    = 2'b10;  // Combined STOP/ERROR state

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg bit_count_done;  // Registered comparison for timing

    // State transition and data processing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
            bit_count_done <= 0;
        end else begin
            state <= next_state;
            
            // Registered bit count comparison
            bit_count_done <= (bit_count == 7);

            case (state)
                IDLE: begin
                    bit_count <= 0;
                    done <= 0;
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // Right-shift for LSB-first
                    bit_count <= bit_count + 1;
                end
                
                WAIT: begin
                    if (in) begin  // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1;
                    end
                end
            endcase
        end
    end

    // Optimized next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = (in == 0) ? RECEIVE : IDLE;
            RECEIVE: next_state = bit_count_done ? WAIT : RECEIVE;
            WAIT:    next_state = (in == 1) ? IDLE : WAIT;
            default: next_state = IDLE;
        endcase
    end

endmodule