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

always @* begin
    case (1'b1) // one-hot encoding of matches
        match0: out = 4'd0;
        match1: out = 4'd1;
        match2: out = 4'd2;
        match3: out = 4'd3;
        match4: out = 4'd4;
        match5: out = 4'd5;
        match6: out = 4'd6;
        match7: out = 4'd7;
        match8: out = 4'd8;
        match9: out = 4'd9;
        default: out = 4'd0;
    endcase
end

endmodule