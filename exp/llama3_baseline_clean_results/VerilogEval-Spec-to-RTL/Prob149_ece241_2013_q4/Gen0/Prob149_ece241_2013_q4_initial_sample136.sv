module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg prev_s0, prev_s1, prev_s2;

always @(posedge clk) begin
    if(reset) begin
        prev_s0 <= 1'b0;
        prev_s1 <= 1'b0;
        prev_s2 <= 1'b0;
        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_s0 <= s[0];
        prev_s1 <= s[1];
        prev_s2 <= s[2];

        // Determine nominal flow rate based on current water level
        if(s[2] == 1'b1 && s[1] == 1'b1 && s[0] == 1'b1) begin
            // Above s[2], no flow
            fr0 <= 1'b0;
            fr1 <= 1'b0;
            fr2 <= 1'b0;
            dfr <= 1'b0;
        end else if(s[2] == 1'b0 && s[1] == 1'b1 && s[0] == 1'b1) begin
            // Between s[2] and s[1], fr0
            fr0 <= 1'b1;
            fr1 <= 1'b0;
            fr2 <= 1'b0;
        end else if(s[2] == 1'b0 && s[1] == 1'b0 && s[0] == 1'b1) begin
            // Between s[1] and s[0], fr0 and fr1
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b0;
        end else begin
            // Below s[0], fr0, fr1, and fr2
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
        end

        // Adjust flow rate based on previous and current water levels
        if((prev_s0 == 1'b0 && s[0] == 1'b1) || (prev_s1 == 1'b0 && s[1] == 1'b1) || (prev_s2 == 1'b0 && s[2] == 1'b1)) begin
            // Previous level was lower than current level, open supplemental flow valve
            dfr <= 1'b1;
        end else begin
            dfr <= 1'b0;
        end
    end
end

endmodule