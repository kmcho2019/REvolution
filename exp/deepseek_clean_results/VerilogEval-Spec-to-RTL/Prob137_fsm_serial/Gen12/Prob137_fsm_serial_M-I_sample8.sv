module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Gray-coded state encoding for reduced switching
    typedef enum logic [1:0] {
        IDLE  = 2'b00,    // Waiting for start bit
        RECEIVE = 2'b01,  // Receiving 8 data bits
        STOP = 2'b11,      // Checking stop bit
        WAIT = 2'b10       // Waiting for valid stop bit
    } state_t;

    reg [1:0] state, next_state;
    reg [1:0] bit_count;  // Reduced to 2 bits (counts 0-7)
    reg [7:0] data_reg;
    reg shift_enable;
    reg done_reg;
    reg count_done;       // Registered comparison for timing

    // Clock-gated shift register with enable
    always @(posedge clk) begin
        if (reset) begin
            data_reg <= 8'b0;
        end else if (shift_enable) begin
            data_reg <= {in, data_reg[7:1]};  // LSB first
        end
    end

    // Registered comparison for timing optimization
    always @(posedge clk) begin
        count_done <= (bit_count == 2'b11);  // Count reaches 7
    end

    // State transition and control logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            done_reg <= 0;
            shift_enable <= 0;
        end else begin
            state <= next_state;
            
            // Counter logic
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 0;
            end
            
            // Conditional done signal generation
            if (state == STOP && in) begin
                done_reg <= 1;
            end else begin
                done_reg <= 0;
            end

            // Clock gating control
            shift_enable <= (next_state == RECEIVE);
        end
    end

    // Optimized next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = in ? IDLE : RECEIVE;
            end
            
            RECEIVE: begin
                next_state = count_done ? STOP : RECEIVE;
            end
            
            STOP: begin
                next_state = in ? IDLE : WAIT;
            end
            
            WAIT: begin
                next_state = in ? IDLE : WAIT;
            end
            
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule