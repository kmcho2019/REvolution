module TopModule (
    input x,
    input y,
    output reg z
);
    reg prev_equal;
    wire current_equal = (x == y);
    
    always @* begin
        z = current_equal && prev_equal;
        prev_equal = current_equal;
    end
endmodule