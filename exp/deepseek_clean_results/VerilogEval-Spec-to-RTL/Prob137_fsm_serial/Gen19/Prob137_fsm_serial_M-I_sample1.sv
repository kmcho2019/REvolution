module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding for better timing
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    localparam WAIT    = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;
    reg done_reg, done_clear;
    reg bit_count_max;

    // Registered bit_count comparison
    always @(posedge clk) begin
        if (reset) begin
            bit_count_max <= 1'b0;
        end else begin
            bit_count_max <= (bit_count == 3'b111);
        end
    end

    // Shift register with clock enable
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
        end else if (shift_enable) begin
            shift_reg <= {in, shift_reg[7:1]};  // LSB first
        end
    end

    // State and control logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            done_reg <= 1'b0;
            done_clear <= 1'b0;
        end else begin
            state <= next_state;
            
            // Counter logic
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 3'b0;
            end
            
            // Done signal handling
            if (done_clear) begin
                done_reg <= 1'b0;
            end else if (state == STOP && in) begin
                done_reg <= 1'b1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        shift_enable = 1'b0;
        done_clear = 1'b0;
        
        case (1'b1)  // synthesis parallel_case
            state[0]: begin // IDLE
                if (!in) begin
                    next_state = RECEIVE;
                    shift_enable = 1'b1;
                end
            end
            
            state[1]: begin // RECEIVE
                shift_enable = 1'b1;
                if (bit_count_max) begin
                    next_state = STOP;
                    done_clear = 1'b1;
                end
            end
            
            state[2]: begin // STOP
                if (in) begin
                    next_state = IDLE;
                end else begin
                    next_state = WAIT;
                end
                done_clear = 1'b1;
            end
            
            state[3]: begin // WAIT
                if (in) begin
                    next_state = IDLE;
                end
                done_clear = 1'b1;
            end
        endcase
    end

    assign done = done_reg;

endmodule