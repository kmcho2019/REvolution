module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

always @(a, b, c, d, e) begin
    case (c[0])
        1'b0: q = b;
        1'b1: q = e;
    endcase
    
    if (c == 4'd2) begin
        q = a;
    end else if (c == 4'd3) begin
        q = d;
    end else if (c > 4'd3) begin
        q = 4'b1111;
    end
end

endmodule