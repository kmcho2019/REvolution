module TopModule(
    input  [3:0] x,
    output reg f
);

always @(x) begin
    if ((x[3] == 0 && x[0] == 1 && x[1] == 1 && x[2] == 1) ||
        (x[3] == 1 && x[0] == 1) ||
        (x[3] == 1 && x[0] == 0 && (x[1] == 0 && x[2] == 0 || x[1] == 0 && x[2] == 1))) begin
        f = 1;
    end else begin
        f = 0;
    end
end

endmodule