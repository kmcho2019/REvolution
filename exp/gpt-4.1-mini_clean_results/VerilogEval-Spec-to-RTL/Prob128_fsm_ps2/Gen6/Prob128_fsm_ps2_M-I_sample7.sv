module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // One-hot state encoding: IDLE=001, BYTE1=010, BYTE2=100
    reg [2:0] state, next_state;

    localparam IDLE  = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for first byte with in[3]==1
                if (in[3])
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end
            BYTE1: begin
                // Accept second byte unconditionally
                next_state = BYTE2;
            end
            BYTE2: begin
                // Accept third byte unconditionally, then go to IDLE
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // done asserted combinationally: when state=BYTE2 (meaning 2 bytes received)
    // and clock is at next cycle (third byte received, so done on next cycle)
    // Since done is a one-cycle pulse immediately after 3rd byte, done should be 
    // high when next_state == IDLE and current state == BYTE2
    assign done = (state == BYTE2);

endmodule