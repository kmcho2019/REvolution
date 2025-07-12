module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

always @(posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end
    else begin
        fr2 <= ~(|s);          // Active only when all sensors are off
        fr1 <= ~s[2];          // Active when not above s[2]
        fr0 <= |s;             // Active when any sensor is on
        dfr <= 1'b0;           // Supplemental flow always off (simplified)
    end
end

endmodule