module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    // Define states
    localparam IDLE  = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP = 2'b10;
    localparam ERROR = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg done_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            
            case (state)
                RECEIVE: begin
                    if (bit_count < 7)
                        bit_count <= bit_count + 1;
                    else
                        bit_count <= 0;
                end
                default: bit_count <= 0;
            endcase
            
            // Done signal is high for one cycle when stop bit is valid
            done_reg <= (next_state == IDLE) && (state == STOP);
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 0) ? RECEIVE : IDLE;
            end
            
            RECEIVE: begin
                if (bit_count == 7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end
            
            STOP: begin
                next_state = (in == 1) ? IDLE : ERROR;
            end
            
            ERROR: begin
                next_state = (in == 1) ? IDLE : ERROR;
            end
            
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule