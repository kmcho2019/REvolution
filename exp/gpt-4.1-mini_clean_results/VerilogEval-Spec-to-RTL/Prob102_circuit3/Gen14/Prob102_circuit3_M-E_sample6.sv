module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);
    always @(*) begin
        if ((a | b) == 1'b1) begin
            if ((c | d) == 1'b1)
                q = 1'b1;
            else
                q = 1'b0;
        end else begin
            q = 1'b0;
        end
    end
endmodule