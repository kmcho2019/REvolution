module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam STOP_WAIT = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    wire done;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_reg <= 8'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                end
                
                RECEIVE: begin
                    data_reg <= {in, data_reg[7:1]};  // LSB first
                    bit_count <= bit_count + 1;
                end
                
                STOP_WAIT: begin
                    // No operations needed, just waiting for stop bit
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 1'b0) ? RECEIVE : IDLE;
            end
            
            RECEIVE: begin
                next_state = (&bit_count) ? STOP_WAIT : RECEIVE;  // bit_count == 7
            end
            
            STOP_WAIT: begin
                next_state = (in == 1'b1) ? IDLE : STOP_WAIT;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Done is high for one cycle when valid stop bit is detected
    assign done = (state == STOP_WAIT) && (in == 1'b1);

endmodule