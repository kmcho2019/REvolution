module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] h;
reg [5:0] m;
reg [5:0] s;
reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        h <= 1; // 01
        m <= 0; // 00
        s <= 0; // 00
        pm_reg <= 0;
    end else if (ena) begin
        if (s == 59) begin
            s <= 0; // 00
            if (m == 59) begin
                m <= 0; // 00
                if (h == 12) begin
                    h <= 1; // 01
                    pm_reg <= ~pm_reg;
                end else if (h == 12 + 1) begin
                    h <= 1; // 01
                    pm_reg <= ~pm_reg;
                end else begin
                    h <= h + 1;
                end
            end else begin
                m <= m + 1;
            end
        end else begin
            s <= s + 1;
        end
    end
end

assign hh = {4'b0, h};
assign mm = {2'b0, m[5:4], m[3:0]};
assign ss = {2'b0, s[5:4], s[3:0]};
assign pm = pm_reg;

endmodule