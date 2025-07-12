module TopModule (
    input  clk,
    input  reset,
    input  [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Define states
enum logic [1:0] {
    STATE_LOW,  // below s[0]
    STATE_MID,  // between s[0] and s[1]
    STATE_HIGH, // between s[1] and s[2]
    STATE_TOP   // above s[2]
} state, next_state;

// Define previous state for flow rate control
logic [1:0] prev_state;

always @(*) begin
    case (state)
        STATE_LOW: next_state = (s[0] == 1'b1)? STATE_MID : STATE_LOW;
        STATE_MID: next_state = (s[1] == 1'b1)? STATE_HIGH : (s[0] == 1'b0)? STATE_LOW : STATE_MID;
        STATE_HIGH: next_state = (s[2] == 1'b1)? STATE_TOP : (s[1] == 1'b0)? STATE_MID : STATE_HIGH;
        STATE_TOP: next_state = (s[2] == 1'b0)? STATE_HIGH : STATE_TOP;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= STATE_LOW;
        prev_state <= STATE_LOW;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        state <= next_state;
        prev_state <= state;

        case (state)
            STATE_LOW: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (prev_state == STATE_MID || prev_state == STATE_HIGH || prev_state == STATE_TOP)? 1'b1 : 1'b0;
            end
            STATE_MID: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (prev_state == STATE_LOW)? 1'b1 : 1'b0;
            end
            STATE_HIGH: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (prev_state == STATE_MID || prev_state == STATE_LOW)? 1'b1 : 1'b0;
            end
            STATE_TOP: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase
    end
end

endmodule