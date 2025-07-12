module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Binary encoded states
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam STOP_WAIT = 2'b10;
    
    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Continuous assignment for done signal
    assign done = (state == STOP_WAIT) && (in == 1'b1);

    // Shift register with explicit enable
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
        end else if (state == RECEIVE) begin
            shift_reg <= {in, shift_reg[7:1]};  // LSB first
        end
    end

    // State transition and counter logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
        end else begin
            state <= next_state;
            bit_count <= (state == RECEIVE) ? bit_count + 1 : 3'b0;
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = in ? IDLE : RECEIVE;
            end
            
            RECEIVE: begin
                next_state = (bit_count == 3'b111) ? STOP_WAIT : RECEIVE;
            end
            
            STOP_WAIT: begin
                next_state = in ? IDLE : STOP_WAIT;
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule