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
reg prev_reset;

always @(posedge clk) begin
    if (reset) begin
        prev_s <= 3'b000;
        prev_reset <= 1'b1;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_s <= s;
        prev_reset <= 1'b0;
        if (~s[2] && ~s[1] && ~s[0]) begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else if (~s[2] && ~s[1] && s[0]) begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= (s[0] && (~prev_s[0] || prev_reset));
        end else if (~s[2] && s[1] && s[0]) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            dfr <= (s[1] && (~prev_s[1] || prev_reset));
        end else if (s[2] && s[1] && s[0]) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end
    end
end

endmodule