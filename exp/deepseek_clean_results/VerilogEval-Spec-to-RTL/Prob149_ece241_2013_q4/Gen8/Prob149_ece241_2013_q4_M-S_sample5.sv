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
        {fr2, fr1, fr0, dfr} <= 4'b1111;
    end
    else begin
        fr2 <= ~(|s);          // Max flow when all sensors off
        fr1 <= ~s[1] & ~s[2];  // Medium flow when below s[1]
        fr0 <= ~s[2];          // Min flow when below s[2]
        dfr <= 1'b0;           // Simplified - no transition tracking
    end
end

endmodule