module TopModule (
    input x,
    input y,
    output reg z
);
    reg prev_equal;
    
    always @* begin
        if ((x == y) && prev_equal)
            z = 1;
        else
            z = 0;
    end
    
    always @* begin
        prev_equal = (x == y);
    end
endmodule