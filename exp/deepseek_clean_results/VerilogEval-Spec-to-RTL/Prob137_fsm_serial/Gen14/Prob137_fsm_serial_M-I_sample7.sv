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
    reg done_reg;

    // Shift register with direct assignment (simpler implementation)
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
        end else if (state == RECEIVE) begin
            shift_reg <= {in, shift_reg[7:1]};  // LSB first
        end
    end

    // State and control logic with pre-computed counter comparison
    wire bit_count_done = (bit_count == 3'b111);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            
            // Counter logic
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 3'b0;
            end
            
            // Level-triggered done signal
            if (state == STOP && in) begin
                done_reg <= 1'b1;
            end else if (state != STOP) begin
                done_reg <= 1'b0;
            end
        end
    end

    // Next state logic with simplified transitions
    always @(*) begin
        next_state = state;
        
        case (1'b1)  // synthesis parallel_case
            state[0]: begin // IDLE
                if (!in) next_state = RECEIVE;
            end
            
            state[1]: begin // RECEIVE
                if (bit_count_done) next_state = STOP;
            end
            
            state[2]: begin // STOP
                if (in) next_state = IDLE;
                else next_state = WAIT;
            end
            
            state[3]: begin // WAIT
                if (in) next_state = IDLE;
            end
        endcase
    end

    assign done = done_reg;

endmodule