module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

always @(*)
begin
    if ((x3 == 0 && x2 == 0 && x1 == 0) || (x3 == 0 && x2 == 0 && x1 == 1)) begin
        f = 0;
    end else if ((x3 == 0 && x2 == 1 && x1 == 0) || (x3 == 0 && x2 == 1 && x1 == 1)) begin
        f = 1;
    end else if ((x3 == 1 && x2 == 0 && x1 == 0)) begin
        f = 0;
    end else if ((x3 == 1 && x2 == 0 && x1 == 1)) begin
        f = 1;
    end else if ((x3 == 1 && x2 == 1 && x1 == 0)) begin
        f = 0;
    end else if ((x3 == 1 && x2 == 1 && x1 == 1)) begin
        f = 1;
    end
end

endmodule