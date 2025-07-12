module TopModule (
    input  [3:0] x,
    output      f
);
    wire [3:0] addr = {x[2], x[3], x[0], x[1]};
    assign f = 16'hB705[addr];
endmodule