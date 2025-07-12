module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

always @(*) begin
    if (c == 4'd0) begin
        q = b;
    end else if (c == 4'd1) begin
        q = e;
    end else if (c == 4'd2) begin
        q = a;
    end else if (c == 4'd3) begin
        q = d;
    end else begin
        q = 4'hF;
    end
end

endmodule