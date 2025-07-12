module TopModule (
    input x,
    input y,
    output reg z
);
    always @* begin
        z = (x == y);
    end
endmodule