module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s, // sensors
    output reg fr2, // Nominal flow valve
    output reg fr1, // Supplemental flow valve 1
    output reg fr0, // Supplemental flow valve 0
    output reg dfr  // Supplemental flow valve
);

reg prev_s2, prev_s1, prev_s0; // previous sensor values

always @(posedge clk) begin
    if (reset) begin // synchronous reset
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s2 <= 1'b0;
        prev_s1 <= 1'b0;
        prev_s0 <= 1'b0;
    end else begin
        prev_s2 <= s[2];
        prev_s1 <= s[1];
        prev_s0 <= s[0];
        
        // Determine output flow rates based on current and previous states
        if (s[2] && s[1] && s[0]) begin // water level above s[2]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (s[1] && s[0] && !s[2]) begin // water level between s[2] and s[1]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            if (prev_s2 || prev_s1 || !prev_s0) begin // level increased
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (s[0] && !s[1] && !s[2]) begin // water level between s[1] and s[0]
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            if (prev_s1 || prev_s0) begin // level increased
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else begin // water level below s[0]
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            if (prev_s0) begin // level increased
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end
    end
end

endmodule