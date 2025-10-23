module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam WAIT    = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    reg done_reg;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_reg <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            
            // Default assignments
            done_reg <= 1'b0;
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    data_reg <= 8'b0;
                end
                
                RECEIVE: begin
                    data_reg <= {in, data_reg[7:1]};  // LSB first
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    if (in) begin
                        done_reg <= 1'b1;  // Valid stop bit
                    end
                end
                
                WAIT: begin
                    // No operations needed, just waiting for stop bit
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (~in) ? RECEIVE : IDLE;
            end
            
            RECEIVE: begin
                next_state = (bit_count == 3'b111) ? STOP : RECEIVE;
            end
            
            STOP: begin
                next_state = in ? IDLE : WAIT;
            end
            
            WAIT: begin
                next_state = in ? IDLE : WAIT;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    assign done = done_reg;

endmodule