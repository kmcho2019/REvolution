module TopModule (
    input  x,
    input  y,
    output reg z
);
    always @* begin
        reg temp;
        temp = x ^ y;
        z = temp & x;
    end
endmodule