module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states (now 3 states)
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg receiving;  // Active during RECEIVE state

    // Combined shift and output register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
            receiving <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;  // Default to 0 (pulsed output)
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    receiving <= 1'b0;
                    if (in == 1'b0) begin
                        receiving <= 1'b1;
                    end
                end
                
                RECEIVE: begin
                    if (receiving) begin
                        out_byte <= {in, out_byte[7:1]};  // Right shift (LSB first)
                        bit_count <= bit_count + 1;
                    end
                end
                
                STOP: begin
                    if (in == 1'b1) begin
                        done <= 1'b1;  // Pulse done for valid stop bit
                    end
                    receiving <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic (optimized)
    always @(*) begin
        case (state)
            IDLE:    next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE: next_state = bit_count[2] ? STOP : RECEIVE;  // bit_count[2] indicates 8 bits received
            STOP:    next_state = (in == 1'b1) ? IDLE : STOP;
            default: next_state = IDLE;
        endcase
    end

endmodule