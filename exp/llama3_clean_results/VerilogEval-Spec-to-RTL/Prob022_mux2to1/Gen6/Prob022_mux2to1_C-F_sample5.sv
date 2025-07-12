module TopModule(
    input a,
    input b,
    input sel,
    output out
);

assign out = (sel == 1'b0) ? a : (sel == 1'b1) ? b : 1'bx;

endmodule