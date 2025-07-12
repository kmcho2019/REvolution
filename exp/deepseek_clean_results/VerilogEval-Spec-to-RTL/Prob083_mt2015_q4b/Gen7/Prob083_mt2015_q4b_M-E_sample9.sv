module TopModule (
    input x,
    input y,
    output reg z
);
    reg prev_x, prev_y;
    
    always @(*) begin
        if (x == y) begin
            z = 1'b1;
        end else begin
            z = 1'b0;
        end
    end
    
    always @(x, y) begin
        prev_x <= x;
        prev_y <= y;
    end
endmodule