module TopModule (
    input wire in,
    output wire out
);
    assign out = in ? 1'b0 : 1'b1;
endmodule