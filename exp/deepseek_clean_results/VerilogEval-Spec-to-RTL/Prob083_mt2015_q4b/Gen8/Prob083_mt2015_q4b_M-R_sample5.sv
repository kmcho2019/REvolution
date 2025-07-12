module TopModule (
    input x,
    input y,
    output reg z
);
    wire prev_equal = (x == y);
    
    always @* begin
        z = (x == y) && prev_equal;
    end
endmodule