module multi_16bit (
    input  clk, 
    input  rst_n, 
    input  start, 
    input  [15:0] ain, 
    input  [15:0] bin, 
    output [31:0] yout, 
    output done
);

reg [3:0] seg0, seg1, seg2, seg3;
reg [15:0] breg;
reg [31:0] pp0, pp1, pp2, pp3;
reg [31:0] yout_r;
reg [4:0] i;
reg done_r;

assign yout = yout_r;
assign done = done_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= #0 0;
        seg0 <= #0 0;
        seg1 <= #0 0;
        seg2 <= #0 0;
        seg3 <= #0 0;
        breg <= #0 0;
        pp0 <= #0 0;
        pp1 <= #0 0;
        pp2 <= #0 0;
        pp3 <= #0 0;
        yout_r <= #0 0;
        done_r <= #0 0;
    end else begin
        if (start && i == 0) begin
            seg0 <= #0 ain[3:0];
            seg1 <= #0 ain[7:4];
            seg2 <= #0 ain[11:8];
            seg3 <= #0 ain[15:12];
            breg <= #0 bin;
        end
        if (start && i > 0 && i < 17) begin
            pp0 <= #0 (seg0 * breg);
            pp1 <= #0 ((seg1 * breg) << 4);
            pp2 <= #0 ((seg2 * breg) << 8);
            pp3 <= #0 ((seg3 * breg) << 12);
            if (i == 16) begin
                yout_r <= #0 pp0 + pp1 + pp2 + pp3;
                done_r <= #0 1;
            end
        end
        if (start && i < 17) begin
            i <= #0 i + 1;
        end else if (!start || i == 17) begin
            i <= #0 0;
            seg0 <= #0 0;
            seg1 <= #0 0;
            seg2 <= #0 0;
            seg3 <= #0 0;
            breg <= #0 0;
            pp0 <= #0 0;
            pp1 <= #0 0;
            pp2 <= #0 0;
            pp3 <= #0 0;
            yout_r <= #0 0;
            done_r <= #0 0;
        end
    end
end

endmodule