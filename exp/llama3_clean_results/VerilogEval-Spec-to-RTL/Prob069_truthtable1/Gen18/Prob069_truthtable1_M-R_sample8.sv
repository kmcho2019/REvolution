module TopModule(
    input x3,
    input x2,
    input x1,
    output reg f
);

always @(*)
begin
    if ((x2 && !x3) || (x1 && x3)) begin
        f = 1'b1;
    end else begin
        f = 1'b0;
    end
end

endmodule