module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // State encoding based on sensor readings
    localparam STATE_ABOVE_S2  = 2'b00;  // s[2:0] = 111
    localparam STATE_BETWEEN_S2_S1 = 2'b01;  // s[2:0] = 011
    localparam STATE_BETWEEN_S1_S0 = 2'b10;  // s[2:0] = 001
    localparam STATE_BELOW_S0  = 2'b11;  // s[2:0] = 000

    reg [1:0] current_state, next_state, prev_state;
    reg is_rising;

    // State transition logic
    always @(*) begin
        case (s)
            3'b111:  next_state = STATE_ABOVE_S2;
            3'b011:  next_state = STATE_BETWEEN_S2_S1;
            3'b001:  next_state = STATE_BETWEEN_S1_S0;
            3'b000:  next_state = STATE_BELOW_S0;
            default: next_state = STATE_BELOW_S0;  // Handle other cases as below s0
        endcase
    end

    // State and transition detection
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_BELOW_S0;
            prev_state <= STATE_BELOW_S0;
            is_rising <= 1'b1;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
            is_rising <= (next_state < current_state);  // State numbers decrease as level rises
        end
    end

    // Output logic
    assign fr0 = (reset) ? 1'b1 : 
                (current_state == STATE_BETWEEN_S2_S1 || 
                 current_state == STATE_BETWEEN_S1_S0 || 
                 current_state == STATE_BELOW_S0);

    assign fr1 = (reset) ? 1'b1 : 
                (current_state == STATE_BETWEEN_S1_S0 || 
                 current_state == STATE_BELOW_S0);

    assign fr2 = (reset) ? 1'b1 : (current_state == STATE_BELOW_S0);

    assign dfr = (reset) ? 1'b1 : 
                (is_rising && (current_state != STATE_ABOVE_S2));

endmodule