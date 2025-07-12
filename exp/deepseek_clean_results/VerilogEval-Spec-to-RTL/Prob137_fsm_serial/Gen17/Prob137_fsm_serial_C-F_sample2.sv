module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // Binary state encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam WAIT    = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_en;

    // State transition and control logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            
            // Bit counter and shift register
            if (shift_en) begin
                shift_reg <= {in, shift_reg[7:1]}; // LSB first
                bit_count <= bit_count + 1;
            end else if (state != RECEIVE) begin
                bit_count <= 3'b0;
            end
            
            // Done signal (pipelined)
            done <= (state == STOP) && (in == 1'b1);
        end
    end

    // Next state and shift enable logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = in ? IDLE : RECEIVE;
                shift_en = ~in;
            end
            
            RECEIVE: begin
                next_state = (bit_count == 3'b111) ? STOP : RECEIVE;
                shift_en = 1'b1;
            end
            
            STOP: begin
                next_state = in ? IDLE : WAIT;
                shift_en = 1'b0;
            end
            
            WAIT: begin
                next_state = in ? IDLE : WAIT;
                shift_en = 1'b0;
            end
            
            default: begin
                next_state = IDLE;
                shift_en = 1'b0;
            end
        endcase
    end

endmodule