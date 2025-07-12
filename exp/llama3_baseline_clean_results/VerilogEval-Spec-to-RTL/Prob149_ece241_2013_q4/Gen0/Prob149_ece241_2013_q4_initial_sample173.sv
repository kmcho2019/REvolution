module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,  // sensor inputs
    output reg fr2,  // flow rate 2
    output reg fr1,  // flow rate 1
    output reg fr0,  // flow rate 0
    output reg dfr   // supplemental flow rate
);

reg prev_s0, prev_s1, prev_s2;

always @(posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s0 <= 1'b0;
        prev_s1 <= 1'b0;
        prev_s2 <= 1'b0;
    end else begin
        // Check if the previous water level was lower than the current level
        if ((s[0] && !prev_s0) || (s[1] && !prev_s1) || (s[2] && !prev_s2)) begin
            dfr <= 1'b1;  // Open the supplemental flow valve
        end else if ((s[0] == prev_s0) && (s[1] == prev_s1) && (s[2] == prev_s2)) begin
            dfr <= 1'b0;  // Close the supplemental flow valve
        end
        
        // Determine the nominal flow rate
        if (s[2]) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
        end else if (s[1]) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
        end else if (s[0]) begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end else begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end
        
        // Update the previous sensor values
        prev_s0 <= s[0];
        prev_s1 <= s[1];
        prev_s2 <= s[2];
    end
end

endmodule