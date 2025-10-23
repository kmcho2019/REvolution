module TopModule (
    input clk,
    input x,
    input y,
    output reg z
);
    reg prev_equal;
    
    always @(posedge clk) begin
        prev_equal <= (x == y);
        z <= (x == y) && prev_equal;
    end
endmodule