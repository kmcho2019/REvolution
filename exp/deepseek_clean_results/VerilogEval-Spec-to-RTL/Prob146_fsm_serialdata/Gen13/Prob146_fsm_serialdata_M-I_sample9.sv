module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Optimized state encoding (one-hot for better timing)
    localparam IDLE    = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP    = 3'b100;

    reg [2:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;

    // Registered next_state for better timing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
            shift_enable <= 1'b0;
        end else begin
            state <= next_state;
            
            // Shift register with enable for power savings
            if (shift_enable) begin
                shift_reg <= {shift_reg[6:0], in};  // Left shift (LSB first)
                bit_count <= bit_count + 1;
            end

            // Pulse done for one cycle when stop bit valid
            done <= (state == STOP) && (in == 1'b1);
            
            // Capture output byte when entering STOP state
            if (next_state == STOP) begin
                out_byte <= shift_reg;
            end

            // Shift enable logic
            shift_enable <= (next_state == RECEIVE);
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 1'b0) ? RECEIVE : IDLE;
            end
            
            RECEIVE: begin
                next_state = (bit_count == 3'b111) ? STOP : RECEIVE;
            end
            
            STOP: begin
                next_state = (in == 1'b1) ? IDLE : IDLE;  // Handle error by going to IDLE
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule