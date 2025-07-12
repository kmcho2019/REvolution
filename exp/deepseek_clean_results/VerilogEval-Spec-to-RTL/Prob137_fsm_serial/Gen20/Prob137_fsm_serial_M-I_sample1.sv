module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Optimized state encoding
    typedef enum logic [1:0] {
        IDLE,      // Waiting for start bit
        RECEIVE,   // Receiving 8 data bits
        STOP      // Checking stop bit (also handles WAIT condition)
    } state_t;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg bit_count_clk_en; // Clock gating for counter
    reg [7:0] data_reg;
    reg data_reg_clk_en;  // Clock gating for shift register
    reg done_reg;
    reg prev_state_IDLE;  // For edge detection on done

    // Clock-gated shift register
    always @(posedge clk) begin
        if (reset) begin
            data_reg <= 8'b0;
        end else if (data_reg_clk_en) begin
            data_reg <= {in, data_reg[7:1]};  // LSB first
        end
    end

    // Clock-gated counter
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 0;
        end else if (bit_count_clk_en) begin
            bit_count <= bit_count + 1;
        end else begin
            bit_count <= 0;
        end
    end

    // State register and control signals
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_reg <= 0;
            prev_state_IDLE <= 1;
        end else begin
            state <= next_state;
            prev_state_IDLE <= (state == IDLE);
            
            // Update done only on falling edge of IDLE (state transition)
            if (prev_state_IDLE && !(next_state == IDLE))
                done_reg <= 0;
            else if ((state == STOP) && in && (next_state == IDLE))
                done_reg <= 1;
        end
    end

    // Next state logic - optimized
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
                if (bit_count == 3'd7) next_state = STOP;
            end
            
            STOP: begin
                if (in) next_state = IDLE;
            end
        endcase
    end

    assign done = done_reg;

endmodule