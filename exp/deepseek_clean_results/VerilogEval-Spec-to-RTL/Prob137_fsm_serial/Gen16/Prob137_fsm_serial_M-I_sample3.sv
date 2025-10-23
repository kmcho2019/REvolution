module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Gray-coded state encoding (optimal for timing/power)
    typedef enum logic [1:0] {
        IDLE  = 2'b00,      // Waiting for start bit
        RECEIVE = 2'b01,    // Receiving 8 data bits
        STOP  = 2'b11,      // Checking stop bit
        WAIT  = 2'b10       // Waiting for valid stop bit
    } state_t;

    reg [1:0] state, next_state;
    reg [1:0] bit_count;    // Reduced to 2 bits (counts 0-3 twice)
    reg bit_count_done;
    reg [7:0] data_reg;
    reg data_reg_clk_en;    // Merged shift and clock enable
    reg done_reg;
    reg bit_count_clk_en;   // New clock gating for bit_count

    // Clock-gated shift register
    always @(posedge clk) begin
        if (reset) begin
            data_reg <= 8'b0;
        end else if (data_reg_clk_en) begin
            data_reg <= {in, data_reg[7:1]};  // LSB first
        end
    end

    // State transition and control logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            bit_count_done <= 0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            
            // Pipelined counter logic
            if (bit_count_clk_en) begin
                bit_count <= bit_count + 1;
                // Compare when bit_count is 3 (after 4 bits) and 7 (after 8 bits)
                bit_count_done <= (bit_count == 2'b11);
            end else if (state != RECEIVE) begin
                bit_count <= 0;
                bit_count_done <= 0;
            end
            
            // Conditional done signal update
            if (state == STOP) begin
                done_reg <= in;
            end else if (state != WAIT) begin
                done_reg <= 0;
            end
        end
    end

    // Next state and control logic - optimized
    always @(*) begin
        next_state = state;
        data_reg_clk_en = 0;
        bit_count_clk_en = 0;
        
        case (state)
            IDLE: begin
                if (!in) next_state = RECEIVE;
            end
            
            RECEIVE: begin
                data_reg_clk_en = 1;
                bit_count_clk_en = 1;
                if (bit_count_done) next_state = STOP;
            end
            
            STOP: begin
                if (in) next_state = IDLE;
                else next_state = WAIT;
            end
            
            WAIT: begin
                if (in) next_state = IDLE;
            end
        endcase
    end

    assign done = done_reg;

endmodule