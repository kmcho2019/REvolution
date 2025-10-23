module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s;

assign fr2 = (s[0] == 1'b0 && s[1] == 1'b0 && s[2] == 1'b0)? 1'b1 : 1'b0;
assign fr1 = (s[0] == 1'b1 && s[1] == 1'b0 && s[2] == 1'b0) || (s[0] == 1'b0 && s[1] == 1'b0 && s[2] == 1'b0)? 1'b1 : 1'b0;
assign fr0 = (s[0] == 1'b1 && s[1] == 1'b0 && s[2] == 1'b0) || (s[0] == 1'b1 && s[1] == 1'b1 && s[2] == 1'b0) || (s[0] == 1'b0 && s[1] == 1'b0 && s[2] == 1'b0)? 1'b1 : 1'b0;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        prev_s <= 3'b000;
        dfr <= 1'b1;
    end else begin
        prev_s <= s;
        if ((s[0] == 1'b1 && prev_s[0] == 1'b0) || (s[1] == 1'b1 && prev_s[1] == 1'b0) || (s[2] == 1'b1 && prev_s[2] == 1'b0)) begin
            dfr <= 1'b1;
        end else if ((s[0] == 1'b0 && prev_s[0] == 1'b1) || (s[1] == 1'b0 && prev_s[1] == 1'b1) || (s[2] == 1'b0 && prev_s[2] == 1'b1)) begin
            dfr <= 1'b0;
        end else begin
            dfr <= dfr;
        end
    end
end

endmodule