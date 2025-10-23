module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Binary state encoding (optimal for small FSMs)
    typedef enum logic [1:0] {
        IDLE,      // Waiting for start bit (00)
        RECEIVE,   // Receiving 8 data bits (01)
        STOP,      // Checking stop bit (10)
        WAIT       // Waiting for valid stop bit (11)
    } state_t;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg bit_count_done;  // Registered comparison
    reg [7:0] data_reg;
    reg shift_enable;
    reg done_reg;
    reg data_reg_clk_en; // Clock gating control

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
            
            // Counter logic with registered comparison
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
                bit_count_done <= (bit_count == 3'b110); // Pre-compute
            end else begin
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
        shift_enable = 0;
        data_reg_clk_en = 0;
        
        case (state)
            IDLE: begin
                if (!in) next_state = RECEIVE;
            end
            
            RECEIVE: begin
                shift_enable = 1;
                data_reg_clk_en = 1;
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