module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Efficient binary state encoding with clear names
    typedef enum logic [1:0] {
        IDLE,      // Waiting for start bit (00)
        RECEIVE,   // Receiving 8 data bits (01)
        STOP,      // Checking stop bit (10)
        WAIT       // Waiting for valid stop bit (11)
    } state_t;

    reg [1:0] state, next_state;
    reg [1:0] bit_count;  // Reduced from 3 to 2 bits (counts 0-7)
    reg [7:0] data_reg;
    reg shift_enable;
    reg done_reg;
    reg bit_count_full;   // Registered comparison for timing

    // Clock-gated shift register with aggressive enable
    always @(posedge clk) begin
        if (reset) begin
            data_reg <= 8'b0;
        end else if (shift_enable && (state == RECEIVE)) begin
            data_reg <= {in, data_reg[7:1]};  // LSB first
        end
    end

    // Registered bit_count comparison for timing
    always @(posedge clk) begin
        if (reset) begin
            bit_count_full <= 0;
        end else begin
            bit_count_full <= (bit_count == 2'b11);  // Counts 0-7
        end
    end

    // State transition and control logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            
            // Counter logic
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 0;
            end
            
            // Conditional done signal generation
            if (state == STOP) begin
                done_reg <= in;
            end else if (state != RECEIVE) begin
                done_reg <= 0;
            end
        end
    end

    // Optimized next state logic
    always @(*) begin
        next_state = state;
        shift_enable = 0;
        
        case (state)
            IDLE: begin
                if (!in) next_state = RECEIVE;
            end
            
            RECEIVE: begin
                shift_enable = 1;
                if (bit_count_full) next_state = STOP;
            end
            
            STOP: begin
                next_state = in ? IDLE : WAIT;
            end
            
            WAIT: begin
                if (in) next_state = IDLE;
            end
        endcase
    end

    assign done = done_reg;

endmodule