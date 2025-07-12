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
    reg [7:0] data_reg;
    reg done_reg;
    reg last_bit_flag;  // Registered version of (bit_count == 3'b111)

    // Clock gating control for data_reg
    wire data_reg_en = (state == RECEIVE);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_reg <= 8'b0;
            done_reg <= 1'b0;
            last_bit_flag <= 1'b0;
        end else begin
            state <= next_state;
            last_bit_flag <= (bit_count == 3'b110);  // Pre-calculate for next cycle
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    done_reg <= 1'b0;
                end
                
                RECEIVE: begin
                    if (data_reg_en) begin
                        data_reg <= {in, data_reg[7:1]};  // LSB first
                    end
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    done_reg <= in;  // Assert done only if stop bit is 1
                end
                
                ERROR: begin
                    // Wait for stop bit, no register updates needed
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = (~in) ? RECEIVE : IDLE;
            RECEIVE: next_state = last_bit_flag ? STOP : RECEIVE;
            STOP:    next_state = in ? IDLE : ERROR;
            ERROR:   next_state = in ? IDLE : ERROR;
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule