module TopModule(
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
        prev_s <= 3'b000;
    end else begin
        prev_s <= s;
    end
end

assign fr2 = (s[0] && s[1] &&!s[2])? 1'b0 : (s[0] &&!s[1] &&!s[2])? 1'b0 :!s[0]? 1'b1 : 1'b0;
assign fr1 = (s[0] && s[1])? 1'b0 : (s[0] &&!s[1])? 1'b1 :!s[0]? 1'b1 : 1'b0;
assign fr0 = (s[0])? 1'b1 :!s[0]? 1'b1 : 1'b0;
assign dfr = (s[0] &&!prev_s[0]) || (s[1] &&!prev_s[1]) || (s[2] &&!prev_s[2]) ||!s[0]? 1'b1 : 1'b0;

endmodule