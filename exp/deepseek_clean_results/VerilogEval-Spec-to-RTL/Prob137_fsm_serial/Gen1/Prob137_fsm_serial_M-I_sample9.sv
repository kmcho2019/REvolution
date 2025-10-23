module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // One-hot state encoding
    localparam IDLE  = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP  = 4'b0100;
    localparam WAIT  = 4'b1000;
    
    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;  // Clock gating control

    // Clock gating for shift register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            done <= 0;
            
            if (shift_enable) begin
                shift_reg <= {in, shift_reg[7:1]};  // Shift in LSB first
                bit_count <= bit_count + 1;
            end
            
            if (state == STOP && in == 1) begin
                done <= 1;  // Valid stop bit
            end
        end
    end

    // Next state and control logic
    always @(*) begin
        next_state = state;
        shift_enable = 0;
        
        case (1'b1)  // Synthesis-safer one-hot case statement
            state[0]: begin // IDLE
                if (in == 0) begin
                    next_state = RECEIVE;
                    shift_enable = 1;
                end
            end
            
            state[1]: begin // RECEIVE
                shift_enable = 1;
                if (bit_count == 7) begin
                    next_state = STOP;
                    shift_enable = 0;
                end
            end
            
            state[2]: begin // STOP
                if (in == 1) begin
                    next_state = IDLE;
                end else begin
                    next_state = WAIT;
                end
            end
            
            state[3]: begin // WAIT
                if (in == 1) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule