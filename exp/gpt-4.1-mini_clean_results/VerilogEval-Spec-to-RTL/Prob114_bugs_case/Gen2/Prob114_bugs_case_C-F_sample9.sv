module TopModule (
    input  [7:0] code,
    output reg [3:0] out,
    output       valid
);

wire match0 = (code == 8'h45);
wire match1 = (code == 8'h16);
wire match2 = (code == 8'h1e);
wire match3 = (code == 8'h26);
wire match4 = (code == 8'h25);
wire match5 = (code == 8'h2e);
wire match6 = (code == 8'h36);
wire match7 = (code == 8'h3d);
wire match8 = (code == 8'h3e);
wire match9 = (code == 8'h46);

assign valid = match0 | match1 | match2 | match3 | match4 | match5 | match6 | match7 | match8 | match9;

always @(*) begin
    case (code)
        8'h45: out = 4'd0;
        8'h16: out = 4'd1;
        8'h1e: out = 4'd2;
        8'h26: out = 4'd3;
        8'h25: out = 4'd4;
        8'h2e: out = 4'd5;
        8'h36: out = 4'd6;
        8'h3d: out = 4'd7;
        8'h3e: out = 4'd8;
        8'h46: out = 4'd9;
        default: out = 4'd0;
    endcase
end

endmodule