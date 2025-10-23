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

always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        prev_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Store previous sensor state
        prev_s <= s;
        
        // Determine output signals based on sensor inputs
        if (~s[2] && ~s[1] && ~s[0]) begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end else if (~s[2] && ~s[1] && s[0]) begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end else if (~s[2] && s[1] && s[0]) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
        end else if (s[2] && s[1] && s[0]) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
        end
        
        // Determine supplemental flow rate (dfr) signal
        if (s > prev_s) begin
            dfr <= 1'b1;
        end else begin
            dfr <= 1'b0;
        end
    end
end

endmodule