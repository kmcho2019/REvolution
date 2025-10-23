module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot FSM states
    localparam IDLE    = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP    = 3'b100;

    reg [2:0] state, next_state;
    reg [1:0] bit_count;  // Reduced to 2 bits
    reg [7:0] shift_reg;
    reg next_state_reg;

    // State transition with registered next_state
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            next_state_reg <= IDLE;
            bit_count <= 2'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state_reg;
            next_state_reg <= next_state;
            
            // Shift register with enable
            if (state == RECEIVE) begin
                shift_reg <= {shift_reg[6:0], in};  // Left shift (LSB first)
                bit_count <= bit_count + 1;
            end else begin
                shift_reg <= shift_reg;
            end

            // Pulse done signal
            done <= (state == STOP) && (in == 1'b1);
            
            // Capture output byte
            if ((state == RECEIVE) && (bit_count == 2'b11)) begin
                out_byte <= {shift_reg[6:0], in};
            end
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 1'b0) ? RECEIVE : IDLE;
            end
            
            RECEIVE: begin
                if (bit_count == 2'b11) begin  // Count to 7 (3 cycles)
                    next_state = STOP;
                end else begin
                    next_state = RECEIVE;
                end
            end
            
            STOP: begin
                next_state = (in == 1'b1) ? IDLE : IDLE;  // Merge error handling
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule