module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] prev_s;

always @ (posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        if ((s[0] && s[1] && s[2]) || (s == prev_s)) begin
            fr2 <= (s[0] && s[1] && s[2]) ? 1'b0 : ((s[0] && s[1]) ? 1'b0 : ((s[0]) ? 1'b0 : 1'b1));
            fr1 <= (s[0] && s[1] && s[2]) ? 1'b0 : ((s[0] && s[1]) ? 1'b0 : (s[0] ? 1'b0 : 1'b1));
            fr0 <= (s[0] && s[1] && s[2]) ? 1'b0 : ((s[0] && s[1]) ? 1'b0 : (s[0] ? 1'b0 : 1'b1));
            dfr <= 1'b0;
        end else if (s > prev_s) begin
            fr2 <= (s[0] && s[1]) ? 1'b0 : ((s[0]) ? 1'b0 : 1'b1);
            fr1 <= (s[0] && s[1]) ? 1'b0 : (s[0] ? 1'b0 : 1'b1);
            fr0 <= (s[0] && s[1]) ? 1'b0 : (s[0] ? 1'b0 : 1'b1);
            dfr <= 1'b1;
        end else begin
            fr2 <= (s[0] && s[1]) ? 1'b0 : ((s[0]) ? 1'b0 : 1'b1);
            fr1 <= (s[0] && s[1]) ? 1'b0 : (s[0] ? 1'b0 : 1'b1);
            fr0 <= (s[0] && s[1]) ? 1'b0 : (s[0] ? 1'b0 : 1'b1);
            dfr <= 1'b0;
        end
        prev_s <= s;
    end
end

endmodule