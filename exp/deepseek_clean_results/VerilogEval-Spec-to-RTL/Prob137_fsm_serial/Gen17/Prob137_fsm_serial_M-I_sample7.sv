module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // Binary encoded states (3 states)
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam STOP_WAIT = 2'b10;
    
    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;

    // Clock gated shift register
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
        end else if (shift_enable) begin
            shift_reg <= {in, shift_reg[7:1]};  // LSB first
        end
    end

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            
            // Counter logic
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 3'b0;
            end
            
            // Done signal (now combinationally generated)
            done <= (state == STOP_WAIT) && (in == 1'b1) && (bit_count == 3'b0);
        end
    end

    // Next state and control logic
    always @(*) begin
        next_state = state;
        shift_enable = 1'b0;
        
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state = RECEIVE;
                end
            end
            
            RECEIVE: begin
                shift_enable = 1'b1;
                if (bit_count == 3'b111) begin
                    next_state = STOP_WAIT;
                end
            end
            
            STOP_WAIT: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule