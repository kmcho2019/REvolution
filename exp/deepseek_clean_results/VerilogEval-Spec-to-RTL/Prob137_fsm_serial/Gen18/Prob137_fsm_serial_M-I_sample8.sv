module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding (better for power in small FSMs)
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    localparam WAIT    = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    reg data_reg_clk_en;
    reg done_reg;

    // Clock-gated shift register
    always @(posedge clk) begin
        if (reset) begin
            data_reg <= 8'b0;
        end else if (data_reg_clk_en) begin
            data_reg <= {in, data_reg[7:1]};  // LSB first
        end
    end

    // State register and control signals
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            
            // Counter with direct comparison in state logic
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 0;
            end
            
            // Simplified done signal generation
            done_reg <= (state == STOP) && in;
        end
    end

    // Next state logic - optimized combination
    always @(*) begin
        next_state = state;
        data_reg_clk_en = 0;
        
        case (1'b1) // synthesis parallel_case
            state[0]: begin // IDLE
                if (!in) begin
                    next_state = RECEIVE;
                    data_reg_clk_en = 1;
                end
            end
            
            state[1]: begin // RECEIVE
                data_reg_clk_en = 1;
                if (bit_count == 3'd7) next_state = STOP;
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