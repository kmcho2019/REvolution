module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

reg a, b, c, d;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        a <= 1'b1;
        b <= 1'b0;
        c <= 1'b0;
        d <= 1'b0;
    end else begin
        case ({a, b, c, d})
            4'b1000: begin
                a <= ~in;
                b <= in;
            end
            4'b0100: begin
                b <= in;
                c <= ~in;
            end
            4'b0010: begin
                c <= ~in;
                a <= in;
                d <= in;
            end
            4'b0001: begin
                d <= in;
                c <= ~in;
                b <= in;
            end
            default: begin
                a <= 1'b1;
                b <= 1'b0;
                c <= 1'b0;
                d <= 1'b0;
            end
        endcase
    end
end

always @(*) begin
    out = d;
end

endmodule