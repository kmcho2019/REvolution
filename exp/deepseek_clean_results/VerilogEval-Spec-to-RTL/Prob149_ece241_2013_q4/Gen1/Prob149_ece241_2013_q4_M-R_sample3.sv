module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // One-hot state encoding
    reg state_above_s2;
    reg state_btw_s2_s1;
    reg state_btw_s1_s0;
    reg state_below_s0;

    reg [2:0] prev_s;
    wire rising;

    // Next state and rising detection
    wire next_above_s2  = (s == 3'b111);
    wire next_btw_s2_s1 = (s == 3'b011);
    wire next_btw_s1_s0 = (s == 3'b001);
    wire next_below_s0  = (s == 3'b000);

    // Rising is true if any previously off sensor is now on
    assign rising = ((~prev_s[0] & s[0]) | 
                   ((~prev_s[1] & s[1]) & ~s[0]) | 
                   ((~prev_s[2] & s[2]) & ~s[1] & ~s[0]);

    // State transition and storage
    always @(posedge clk) begin
        if (reset) begin
            state_above_s2  <= 1'b0;
            state_btw_s2_s1 <= 1'b0;
            state_btw_s1_s0 <= 1'b0;
            state_below_s0  <= 1'b1;
            prev_s <= 3'b000;
        end else begin
            state_above_s2  <= next_above_s2;
            state_btw_s2_s1 <= next_btw_s2_s1;
            state_btw_s1_s0 <= next_btw_s1_s0;
            state_below_s0  <= next_below_s0;
            prev_s <= s;
        end
    end

    // Output logic
    assign fr0 = reset ? 1'b1 : (state_btw_s2_s1 | state_btw_s1_s0 | state_below_s0);
    assign fr1 = reset ? 1'b1 : (state_btw_s1_s0 | state_below_s0);
    assign fr2 = reset ? 1'b1 : state_below_s0;
    assign dfr = reset ? 1'b1 : (rising & (state_btw_s2_s1 | state_btw_s1_s0 | state_below_s0));

endmodule