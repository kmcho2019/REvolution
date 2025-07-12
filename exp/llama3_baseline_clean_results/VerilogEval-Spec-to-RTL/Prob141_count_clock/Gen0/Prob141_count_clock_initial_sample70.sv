module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] h1, h0;
reg [3:0] m1, m0;
reg [3:0] s1, s0;
reg pm_int;

always @(posedge clk) begin
    if(reset) begin
        h1 <= 0;
        h0 <= 1; // Default time 12:00:00 AM
        m1 <= 0;
        m0 <= 0;
        s1 <= 0;
        s0 <= 0;
        pm_int <= 0;
    end else if(ena) begin
        if(s1 == 5 && s0 == 9) begin
            s1 <= 0;
            s0 <= 0;
            if(m1 == 5 && m0 == 9) begin
                m1 <= 0;
                m0 <= 0;
                if(h1 == 0 && h0 == 2 && pm_int == 1) begin
                    h1 <= 0;
                    h0 <= 1; // 12:00 PM -> 1:00 AM
                    pm_int <= 0;
                end else if(h1 == 0 && h0 == 1 && pm_int == 0) begin
                    h1 <= 0;
                    h0 <= 2; // 12:00 AM -> 1:00 PM
                    pm_int <= 1;
                end else if(h1 == 1) begin
                    h1 <= 0;
                    h0 <= 3; // Roll over hours, 11:59 -> 12:00
                end else begin
                    h0 <= h0 + 1; // Increment hours
                end
            end else if(m1 == 5 && m0 == 9) begin
                m1 <= 0;
                m0 <= 0; // Roll over minutes, 59 -> 0
            end else begin
                if(m0 == 9) begin
                    m1 <= m1 + 1; // Increment tens of minutes
                    m0 <= 0;
                end else begin
                    m0 <= m0 + 1; // Increment minutes
                end
            end
        end else if(s0 == 9) begin
            s1 <= s1 + 1; // Increment tens of seconds
            s0 <= 0;
        end else begin
            s0 <= s0 + 1; // Increment seconds
        end
    end
end

assign hh = {h1, h0};
assign mm = {m1, m0};
assign ss = {s1, s0};
assign pm = pm_int;

endmodule