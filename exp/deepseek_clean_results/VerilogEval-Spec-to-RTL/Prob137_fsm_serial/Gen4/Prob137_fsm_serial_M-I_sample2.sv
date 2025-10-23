module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // Binary encoded states
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    
    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // State and data registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            
            if (state == RECEIVE) begin
                shift_reg <= {in, shift_reg[7:1]};  // LSB first
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 3'b0;
            end
            
            // Direct done signal (no pipelining)
            done <= (state == RECEIVE && bit_count == 3'b111 && in == 1'b1);
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 1'b0) ? RECEIVE : IDLE;
            end
            
            RECEIVE: begin
                if (bit_count == 3'b111) begin
                    next_state = (in == 1'b1) ? IDLE : STOP;
                end else begin
                    next_state = RECEIVE;
                end
            end
            
            STOP: begin
                next_state = (in == 1'b1) ? IDLE : STOP;
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule