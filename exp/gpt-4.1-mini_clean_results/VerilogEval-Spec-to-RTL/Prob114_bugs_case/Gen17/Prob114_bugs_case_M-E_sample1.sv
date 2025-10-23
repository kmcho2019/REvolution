module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output valid
);

wire key0 = (code == 8'h45);
wire key1 = (code == 8'h16);
wire key2 = (code == 8'h1e);
wire key3 = (code == 8'h26);
wire key4 = (code == 8'h25);
wire key5 = (code == 8'h2e);
wire key6 = (code == 8'h36);
wire key7 = (code == 8'h3d);
wire key8 = (code == 8'h3e);
wire key9 = (code == 8'h46);

assign valid = key0 | key1 | key2 | key3 | key4 | key5 | key6 | key7 | key8 | key9;

// Priority encoder logic for output digit
assign out =   (key0 ? 4'd0 :
               (key1 ? 4'd1 :
               (key2 ? 4'd2 :
               (key3 ? 4'd3 :
               (key4 ? 4'd4 :
               (key5 ? 4'd5 :
               (key6 ? 4'd6 :
               (key7 ? 4'd7 :
               (key8 ? 4'd8 :
               (key9 ? 4'd9 : 4'd0))))))))));

endmodule