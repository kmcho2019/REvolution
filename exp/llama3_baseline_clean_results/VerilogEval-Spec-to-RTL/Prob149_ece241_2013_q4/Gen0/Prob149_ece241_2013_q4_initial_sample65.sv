module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

reg [2:0] prev_s;
reg        prev_fr2, prev_fr1, prev_fr0, prev_dfr;

assign fr2 = (reset || (!s[0] && !s[1] && !s[2])) ? 1'b1 : (s[0] && s[1] && s[2]) ? 1'b0 : 1'b1;
assign fr1 = (reset || (!s[0] && !s[1] && !s[2])) ? 1'b1 : (s[0] && s[1]) ? 1'b1 : (s[0] && !s[1] && !s[2]) ? 1'b1 : 1'b0;
assign fr0 = (reset || (!s[0] && !s[1] && !s[2])) ? 1'b1 : 1'b1;
assign dfr = (reset || (!s[0] && !s[1] && !s[2])) ? 1'b1 : 
             ((s[0] && s[1] && s[2]) || (s[0] && s[1] && !s[2])) ? 1'b0 : 
             ((prev_s[0] == 1'b0 && s[0] == 1'b1) || (prev_s[1] == 1'b0 && s[1] == 1'b1)) ? 1'b1 : 1'b0;

always @(posedge clk) begin
    if (reset) begin
        prev_s <= 3'b000;
    end else begin
        prev_s <= s;
    end
end

endmodule