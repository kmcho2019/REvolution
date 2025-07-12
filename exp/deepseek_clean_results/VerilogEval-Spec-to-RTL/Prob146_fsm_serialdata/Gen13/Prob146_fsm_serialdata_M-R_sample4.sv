module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // Simplified state encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg done_reg;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    if (in == 1'b0) begin
                        shift_reg <= 8'b0;  // Prepare for new byte
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {shift_reg[6:0], in};  // Left shift (LSB first)
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    if (in) begin  // Valid stop bit
                        out_byte <= shift_reg;
                    end
                end
            endcase
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE:    next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_count == 3'b111) ? STOP : RECEIVE;
            STOP:    next_state = in ? IDLE : STOP;  // Wait for stop bit
            default:  next_state = IDLE;
        endcase
    end

    // Done signal pulses for one cycle when valid stop bit detected
    assign done = (state == STOP) && in && !reset;

endmodule