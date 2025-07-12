module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states with gray encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;
    reg next_done;

    // Registered next_state to improve timing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= next_done;
            
            if (shift_enable) begin
                shift_reg <= {shift_reg[6:0], in};  // Left shift (LSB first)
                bit_count <= bit_count + 1;
            end
            
            if (state == STOP && in == 1'b1) begin
                out_byte <= shift_reg;
            end
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;
        shift_enable = 1'b0;
        next_done = 1'b0;
        
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state = RECEIVE;
                    shift_enable = 1'b1;
                end
            end
            
            RECEIVE: begin
                shift_enable = 1'b1;
                if (bit_count == 3'b111) begin
                    next_state = STOP;
                end
            end
            
            STOP: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                    next_done = 1'b1;
                end else begin
                    next_state = IDLE;  // Simplified error handling
                end
            end
        endcase
    end

endmodule