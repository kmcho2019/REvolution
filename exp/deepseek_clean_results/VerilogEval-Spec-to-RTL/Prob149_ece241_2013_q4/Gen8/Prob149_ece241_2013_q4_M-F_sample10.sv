module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s;

always @(posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end
    else begin
        prev_s <= s;
        
        // Default outputs
        fr2 <= 1'b0;
        fr1 <= 1'b0;
        fr0 <= 1'b0;
        dfr <= 1'b0;
        
        // Below s[0] - all sensors off
        if (s == 3'b000) begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end
        // Between s[1] and s[0] - only s[0] on
        else if (s == 3'b001) begin
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end
        // Between s[2] and s[1] - s[1] and s[0] on
        else if (s == 3'b011) begin
            fr0 <= 1'b1;
        end
        // Above s[2] - all sensors on (no outputs)
        
        // Detect rising level (more sensors active than before)
        if ((s > prev_s) && (s != 3'b111)) begin
            dfr <= 1'b1;
        end
    end
end

endmodule