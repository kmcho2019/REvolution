module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] state;
reg [2:0] prev_state;

// Define the states
parameter STATE_below_s0 = 3'b000;
parameter STATE_between_s0_s1 = 3'b001;
parameter STATE_between_s1_s2 = 3'b010;
parameter STATE_above_s2 = 3'b011;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= STATE_below_s0;
        prev_state <= STATE_below_s0;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        case (s)
            3'b000: begin // Below s[0]
                state <= STATE_below_s0;
                if (prev_state != STATE_below_s0) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            3'b001: begin // Between s[0] and s[1]
                state <= STATE_between_s0_s1;
                if (prev_state == STATE_below_s0) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            3'b010, 3'b011: begin // Between s[1] and s[2]
                state <= STATE_between_s1_s2;
                if (prev_state == STATE_between_s0_s1) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
            end
            3'b111: begin // Above s[2]
                state <= STATE_above_s2;
                dfr <= 1'b0;
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
            end
        endcase
        prev_state <= state;
    end
end

endmodule