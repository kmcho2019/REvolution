module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);
    always @(*) begin
        if (a < b) begin
            if (a < c) begin
                if (a < d)
                    min = a;
                else
                    min = d;
            end else begin
                if (c < d)
                    min = c;
                else
                    min = d;
            end
        end else begin
            if (b < c) begin
                if (b < d)
                    min = b;
                else
                    min = d;
            end else begin
                if (c < d)
                    min = c;
                else
                    min = d;
            end
        end
    end
endmodule