module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam ERROR   = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg bit_count_done;  // Registered version of (bit_count == 3'b111)
    reg [7:0] data_reg;
    reg done_reg;
    reg data_reg_en;     // Clock gating for data_reg

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            bit_count_done <= 1'b0;
            data_reg <= 8'b0;
            done_reg <= 1'b0;
            data_reg_en <= 1'b0;
        end else begin
            state <= next_state;
            
            // Update bit_count_done one cycle early to break critical path
            bit_count_done <= (bit_count == 3'b110);
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    done_reg <= 1'b0;
                    data_reg_en <= 1'b0;
                end
                
                RECEIVE: begin
                    bit_count <= bit_count + 1;
                    data_reg_en <= 1'b1;
                end
                
                STOP: begin
                    done_reg <= in;  // Assert done only if stop bit is 1
                    data_reg_en <= 1'b0;
                end
                
                ERROR: begin
                    data_reg_en <= 1'b0;
                end
            endcase
            
            // Clock-gated data register update
            if (data_reg_en) begin
                data_reg <= {in, data_reg[7:1]};  // LSB first
            end
        end
    end

    // Combinational next state logic (simplified)
    always @(*) begin
        case (state)
            IDLE:    next_state = (~in) ? RECEIVE : IDLE;
            RECEIVE: next_state = bit_count_done ? STOP : RECEIVE;
            STOP:    next_state = in ? IDLE : ERROR;
            ERROR:   next_state = in ? IDLE : ERROR;
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule