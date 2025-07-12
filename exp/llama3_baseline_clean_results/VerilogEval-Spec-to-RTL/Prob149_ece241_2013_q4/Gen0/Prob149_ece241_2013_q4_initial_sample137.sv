module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg prev_s0, prev_s1, prev_s2; // previous sensor values
reg state; // state machine state: 0 - not_increasing, 1 - increasing

always @(posedge clk) begin
    if (reset) begin
        // reset state machine to default state
        state <= 0;
        prev_s0 <= 0;
        prev_s1 <= 0;
        prev_s2 <= 0;
        fr0 <= 1;
        fr1 <= 1;
        fr2 <= 1;
        dfr <= 1;
    end else begin
        // update previous sensor values
        prev_s0 <= s[0];
        prev_s1 <= s[1];
        prev_s2 <= s[2];

        // determine nominal flow rate
        if (s[0] && s[1] && s[2]) begin
            // above s[2]
            fr0 <= 0;
            fr1 <= 0;
            fr2 <= 0;
        end else if (s[0] && s[1]) begin
            // between s[2] and s[1]
            fr0 <= 1;
            fr1 <= 0;
            fr2 <= 0;
        end else if (s[0]) begin
            // between s[1] and s[0]
            fr0 <= 1;
            fr1 <= 1;
            fr2 <= 0;
        end else begin
            // below s[0]
            fr0 <= 1;
            fr1 <= 1;
            fr2 <= 1;
        end

        // determine supplemental flow valve
        if ((s[0] > prev_s0) || (s[1] > prev_s1) || (s[2] > prev_s2)) begin
            // water level is increasing
            state <= 1;
            dfr <= 1;
        end else begin
            // water level is not increasing
            state <= 0;
            dfr <= 0;
        end
    end
end

endmodule