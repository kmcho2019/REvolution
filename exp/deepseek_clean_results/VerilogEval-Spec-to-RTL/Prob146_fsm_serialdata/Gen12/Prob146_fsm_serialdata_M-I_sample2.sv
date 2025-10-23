module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states (reduced to 3 states)
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    wire all_bits_received = &bit_count;  // bit_count == 3'b111

    // Combined shift register and output byte
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            out_byte <= 8'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    if (in == 1'b0) begin
                        out_byte <= 8'b0;  // Prepare for new byte
                    end
                end
                
                RECEIVE: begin
                    out_byte <= {in, out_byte[7:1]};  // Right shift (LSB first)
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    // No register updates needed
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE: next_state = all_bits_received ? STOP : RECEIVE;
            STOP:    next_state = (in == 1'b1) ? IDLE : STOP;
            default: next_state = IDLE;
        endcase
    end

    // Combinatorial done signal (pulse when valid stop bit detected)
    always @(*) begin
        done = (state == STOP) && (in == 1'b1);
    end

endmodule