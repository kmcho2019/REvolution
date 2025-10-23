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
            done_reg <= 1'b0;  // Default assignment
            
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    data_reg <= 8'b0;
                end
                
                RECEIVE: begin
                    data_reg <= {in, data_reg[7:1]};  // LSB-first shift
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    if (in) done_reg <= 1'b1;  // Valid stop bit pulse
                end
                
                default: ;  // WAIT state needs no operations
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;  // Default: stay in current state
        
        case (state)
            IDLE:    if (~in) next_state = RECEIVE;
            RECEIVE: if (bit_count == 3'd7) next_state = STOP;
            STOP:    next_state = in ? IDLE : WAIT;
            WAIT:    if (in) next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule