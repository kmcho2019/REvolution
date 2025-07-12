module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding for faster transitions
    typedef enum logic [3:0] {
        IDLE  = 4'b0001,  // Waiting for start bit
        RECEIVE = 4'b0010, // Receiving 8 data bits
        STOP  = 4'b0100,  // Checking stop bit
        WAIT  = 4'b1000   // Waiting for valid stop bit
    } state_t;

    reg [3:0] state, next_state;
    reg [1:0] bit_count;      // Counts 0-3 (4 bits)
    reg bit_count_msb;        // Tracks 4th bit
    reg [7:0] data_reg;
    reg shift_enable;
    reg done_reg;
    reg all_bits_received;    // Registered comparison

    // Clock gating for data_reg
    wire data_clk = clk & shift_enable;

    // Gray-coded bit counter with msb tracking
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 2'b00;
            bit_count_msb <= 0;
        end else if (state == RECEIVE) begin
            {bit_count_msb, bit_count} <= {bit_count_msb, bit_count} + 1;
        end else begin
            bit_count <= 2'b00;
            bit_count_msb <= 0;
        end
    end

    // Registered comparison for timing
    always @(posedge clk) begin
        all_bits_received <= (bit_count == 2'b11) & bit_count_msb;
    end

    // Data register with clock gating
    always @(posedge data_clk or posedge reset) begin
        if (reset) begin
            data_reg <= 8'b0;
        end else begin
            data_reg <= {in, data_reg[7:1]};  // LSB first
        end
    end

    // State transition and control logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_reg <= 0;
        end else begin
            state <= next_state;
            
            // Done signal generation (only update when relevant)
            if ((state == STOP) && in) begin
                done_reg <= 1;
            end else if (state == IDLE) begin
                done_reg <= 0;
            end
        end
    end

    // Next state logic - optimized for timing
    always @(*) begin
        next_state = state;
        shift_enable = 0;
        
        case (1'b1) // synthesis parallel_case
            state[0]: begin // IDLE
                if (!in) next_state = RECEIVE;
            end
            
            state[1]: begin // RECEIVE
                shift_enable = 1;
                if (all_bits_received) next_state = STOP;
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