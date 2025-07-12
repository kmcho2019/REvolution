module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // One-hot state encoding for better timing
    localparam IDLE   = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP   = 4'b0100;
    localparam WAIT   = 4'b1000;
    
    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;  // Control signal for shift register

    // State transition logic (combinational)
    always @(*) begin
        next_state = state;
        shift_enable = 0;
        done = 0;
        
        case (1'b1)  // Synthesis will optimize this case statement
            state[0]: begin // IDLE
                if (!in) begin
                    next_state = RECEIVE;
                end
            end
            
            state[1]: begin // RECEIVE
                shift_enable = 1;
                if (bit_count == 3'd7) begin
                    next_state = STOP;
                end
            end
            
            state[2]: begin // STOP
                if (in) begin
                    done = 1;
                    next_state = IDLE;
                end else begin
                    next_state = WAIT;
                end
            end
            
            state[3]: begin // WAIT
                if (in) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Sequential logic (state and data registers)
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
        end else begin
            state <= next_state;
            
            if (state[0]) begin // IDLE
                bit_count <= 0;
            end
            
            if (shift_enable) begin
                shift_reg <= {in, shift_reg[7:1]};
                bit_count <= bit_count + 1;
            end
        end
    end

endmodule