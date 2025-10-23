module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output       valid
);

    assign out = (
        (code == 8'h45)? 4'h0 :
        (code == 8'h16)? 4'h1 :
        (code == 8'h1e)? 4'h2 :
        (code == 8'h26)? 4'h3 :
        (code == 8'h25)? 4'h4 :
        (code == 8'h2e)? 4'h5 :
        (code == 8'h36)? 4'h6 :
        (code == 8'h3d)? 4'h7 :
        (code == 8'h3e)? 4'h8 :
        (code == 8'h46)? 4'h9 :
        4'h0
    );

    assign valid = (out!= 4'h0);

endmodule