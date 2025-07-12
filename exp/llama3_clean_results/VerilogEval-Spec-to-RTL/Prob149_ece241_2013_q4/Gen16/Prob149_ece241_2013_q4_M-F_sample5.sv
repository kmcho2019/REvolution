module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s; // Register to store previous sensor state

// Sequential logic to update previous sensor state and output signals
always @(posedge clk) begin
    if (reset) begin
        prev_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_s <= s;
        
        // Determine output signals based on sensor states
        if (s[2] && s[1] && s[0]) begin
            // All sensors high, no flow
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
        end else if (s[2] && s[1]) begin
            // Between s[2] and s[1], minimal flow
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
        end else if (s[1]) begin
            // Between s[1] and s[0], moderate flow
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end else begin
            // Below s[0], maximum flow
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end
        
        // Determine supplemental flow rate signal (dfr)
        if ((s[2] > prev_s[2]) || (s[1] > prev_s[1] && !prev_s[2]) || (s[0] > prev_s[0] && !prev_s[1] && !prev_s[2])) begin
            dfr <= 1'b1;
        end else begin
            dfr <= 1'b0;
        end
    end
end

endmodule