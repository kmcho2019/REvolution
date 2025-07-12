module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] h;
reg [3:0] m;
reg [3:0] s;
reg pm_reg;

always @ (posedge clk) begin
    if (reset) begin
        h <= 1; // 12:00 AM
        m <= 0;
        s <= 0;
        pm_reg <= 0; // AM
    end else if (ena) begin
        if (s == 9'd59) begin
            s <= 0;
            if (m == 9'd59) begin
                m <= 0;
                if (h == 9'd12) begin
                    h <= 1;
                    pm_reg <= ~pm_reg; // toggle AM/PM
                end else if (h == 9'd12 - 1) begin
                    h <= 9'd12;
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

assign hh = {4'd0, h};
assign mm = {4'd0, m};
assign ss = {4'd0, s};
assign pm = pm_reg;

endmodule