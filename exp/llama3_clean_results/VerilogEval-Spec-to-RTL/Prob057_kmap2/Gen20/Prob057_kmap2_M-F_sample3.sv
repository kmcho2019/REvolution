module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(a, b, c, d) begin
    if ((~a && ~b && !(c && d)) || 
        (a && b && ((~c && d) || (c && ~d) || (c && d)))) begin
        out = 1'b1;
    end else if ((~a && b && (~c && d)) || 
                 (a && ~b && (~c && ~d)) || 
                 (a && b && (c && d))) begin
        out = 1'b1;
    end else begin
        out = 1'b0;
    end
end

endmodule