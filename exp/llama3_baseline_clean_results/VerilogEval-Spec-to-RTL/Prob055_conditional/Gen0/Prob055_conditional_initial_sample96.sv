module TopModule(a, b, c, d, min);
    input [7:0] a, b, c, d;
    output [7:0] min;

    always @(*)
    begin
        if (a <= b && a <= c && a <= d) begin
            min = a;
        end else if (b <= a && b <= c && b <= d) begin
            min = b;
        end else if (c <= a && c <= b && c <= d) begin
            min = c;
        end else begin
            min = d;
        end
    end
endmodule