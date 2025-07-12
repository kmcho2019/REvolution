module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam WAIT    = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg done_reg;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            done_reg <= 0;  // Default to 0, set only when valid stop bit
            
            case (state)
                IDLE: begin
                    bit_count <= 0;
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // LSB first
                    bit_count <= bit_count + 1;
                    
                    if (bit_count == 3'b111) begin
                        done_reg <= in;  // Set done if stop bit is valid
                    end
                end
                
                WAIT: begin
                    // No action needed, just waiting for line to return to 1
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 0) ? RECEIVE : IDLE;
            end
            
            RECEIVE: begin
                if (bit_count == 3'b111) begin
                    next_state = (in == 1) ? IDLE : WAIT;
                end else begin
                    next_state = RECEIVE;
                end
            end
            
            WAIT: begin
                next_state = (in == 1) ? IDLE : WAIT;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    assign done = done_reg;

endmodule