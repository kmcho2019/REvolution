module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    reg [7:0] min_reg;

    always @(*) begin
        if (a <= b && a <= c && a <= d) begin
            min_reg = a;
        end else if (b <= a && b <= c && b <= d) begin
            min_reg = b;
        end else if (c <= a && c <= b && c <= d) begin
            min_reg = c;
        end else begin
            min_reg = d;
        end
    end

    assign min = min_reg;

endmodule