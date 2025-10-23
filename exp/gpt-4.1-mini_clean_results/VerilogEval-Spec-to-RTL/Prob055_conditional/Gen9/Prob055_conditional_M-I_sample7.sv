module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);
    always @(*) begin
        if (a < b) begin
            if (c < d) begin
                if (a < c) min = a; else min = c;
            end else begin
                if (a < d) min = a; else min = d;
            end
        end else begin
            if (c < d) begin
                if (b < c) min = b; else min = c;
            end else begin
                if (b < d) min = b; else min = d;
            end
        end
    end
endmodule