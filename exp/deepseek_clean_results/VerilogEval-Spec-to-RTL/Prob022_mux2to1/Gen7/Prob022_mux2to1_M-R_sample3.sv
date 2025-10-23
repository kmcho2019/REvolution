module TopModule (
    input wire a,
    input wire b,
    input wire sel,
    output wire out
);
    assign out = (sel == 1'b1) ? b : a;
endmodule