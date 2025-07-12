module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Binary state encoding (optimal for small FSMs)
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam WAIT    = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg bit_count_done;  // Registered comparison
    reg [7:0] data_reg;
    reg data_reg_clk_en; // Clock gating control
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
            bit_count_done <= 0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            
            // Counter with registered comparison
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
                bit_count_done <= (bit_count == 3'd6); // Count 0-7
            end else begin
                bit_count <= 0;
                bit_count_done <= 0;
            end
            
            // Conditional done signal update
            done_reg <= (state == STOP) && in;
        end
    end

    // Next state logic - clear case structure
    always @(*) begin
        next_state = state;
        data_reg_clk_en = 0;
        
        case (state)
            IDLE: begin
                if (!in) begin
                    next_state = RECEIVE;
                    data_reg_clk_en = 1;
                end
            end
            
            RECEIVE: begin
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