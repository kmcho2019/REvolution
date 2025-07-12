module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE     = 2'b00;
    localparam RECEIVING = 2'b01;
    localparam STOP     = 2'b10;
    localparam ERROR    = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    reg done_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_reg <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    done_reg <= 1'b0;
                end
                
                RECEIVING: begin
                    data_reg <= {in, data_reg[7:1]};  // Shift right, LSB first
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    done_reg <= in;  // Assert done only if stop bit is 1
                end
                
                ERROR: begin
                    // Wait here until we see stop bit
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:
                next_state = (in == 1'b0) ? RECEIVING : IDLE;
            
            RECEIVING:
                next_state = (bit_count == 3'b111) ? STOP : RECEIVING;
            
            STOP:
                next_state = (in == 1'b1) ? IDLE : ERROR;
            
            ERROR:
                next_state = (in == 1'b1) ? IDLE : ERROR;
            
            default:
                next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule