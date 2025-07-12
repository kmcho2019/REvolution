module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

always @(*) begin
    if (c == 4'h0) begin
        q = b;
    end else if (c == 4'h1) begin
        q = e;
    end else if (c == 4'h2) begin
        q = a;
    end else if (c == 4'h3) begin
        q = d;
    end else begin
        q = 4'hF;
    end
end

endmodule