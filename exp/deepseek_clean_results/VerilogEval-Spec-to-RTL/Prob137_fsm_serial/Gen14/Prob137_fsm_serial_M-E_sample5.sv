module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Compact state encoding
    typedef enum logic [1:0] {
        WAIT_START,   // Waiting for start bit or valid stop bit
        RECEIVING,    // Receiving data bits
        CHECK_STOP    // Verifying stop bit (could be skipped)
    } state_t;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    reg in_prev;
    wire in_fall_edge = in_prev && !in;
    wire in_rise_edge = !in_prev && in;

    // Edge detector and shift register
    always @(posedge clk) begin
        if (reset) begin
            in_prev <= 1'b1;
            data_reg <= 8'b0;
        end else begin
            in_prev <= in;
            
            // Parallel load when we detect a potential stop bit early
            if (state == RECEIVING && bit_count == 3'd7 && in_rise_edge) begin
                data_reg <= {in_prev, data_reg[7:1]}; // Load all 8 bits
            end
            // Normal shift operation
            else if (state == RECEIVING) begin
                data_reg <= {in, data_reg[7:1]}; // LSB first
            end
        end
    end

    // State transition and counter
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_START;
            bit_count <= 0;
        end else begin
            state <= next_state;
            
            if (state == RECEIVING) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 0;
            end
        end
    end

    // Next state logic with early stop detection
    always @(*) begin
        next_state = state;
        
        case (state)
            WAIT_START: begin
                if (in_fall_edge) next_state = RECEIVING;
            end
            
            RECEIVING: begin
                if (bit_count == 3'd7) begin
                    // Early stop bit detection
                    if (in_rise_edge) next_state = WAIT_START;
                    else next_state = CHECK_STOP;
                end
            end
            
            CHECK_STOP: begin
                if (in) next_state = WAIT_START;
            end
        endcase
    end

    // Combinatorial done signal
    assign done = (state == RECEIVING && bit_count == 3'd7 && in) || 
                 (state == CHECK_STOP && in);

endmodule