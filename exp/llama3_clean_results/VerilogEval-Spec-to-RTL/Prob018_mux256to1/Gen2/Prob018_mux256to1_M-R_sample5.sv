module TopModule(
    input  [255:0] in,
    input  [7:0] sel,
    output out
);

assign out = (sel == 8'd0) ? in[0] :
             (sel == 8'd1) ? in[1] :
             (sel == 8'd2) ? in[2] :
             // ... and so on for all 256 possible values of sel
             (sel == 8'd253) ? in[253] :
             (sel == 8'd254) ? in[254] :
             (sel == 8'd255) ? in[255] : 1'b0;

endmodule