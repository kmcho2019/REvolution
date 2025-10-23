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
            {fr2, fr1, fr0, dfr} <= 4'b1111;
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
            
            // Nominal flow outputs
            fr0 <= (s != 3'b111);            // On for all levels except above s[2]
            fr1 <= (s == 3'b000 || s == 3'b001); // On for below s[0] or between s[0]-s[1]
            fr2 <= (s == 3'b000);            // On only for below s[0]
            
            // Supplemental flow (was level decreasing?)
            dfr <= (s > prev_s);              // On if level was increasing
        end
    end

endmodule