module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states (now 3 states)
    localparam IDLE   = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP   = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_pos;  // Tracks which bit we're receiving (0-7)
    reg [7:0] data_reg; // Combines shift and output register

    // State transition and data processing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_pos <= 3'b0;
            data_reg <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;  // Default to 0 (pulsed signal)

            case (state)
                IDLE: begin
                    bit_pos <= 3'b0;
                    if (in == 1'b0) begin
                        data_reg <= 8'b0;  // Prepare for new byte
                    end
                end
                
                RECEIVE: begin
                    if (bit_pos < 3'b111) begin
                        data_reg <= {in, data_reg[7:1]};  // Right shift (LSB first)
                        bit_pos <= bit_pos + 1;
                    end
                end
                
                STOP: begin
                    if (in == 1'b1) begin  // Valid stop bit
                        out_byte <= data_reg;
                        done <= 1'b1;      // Pulse done for 1 cycle
                    end
                end
            endcase
        end
    end

    // Next state logic (simplified)
    always @(*) begin
        case (state)
            IDLE:   next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_pos == 3'b111) ? STOP : RECEIVE;
            STOP:   next_state = (in == 1'b1) ? IDLE : STOP;
            default: next_state = IDLE;
        endcase
    end

endmodule