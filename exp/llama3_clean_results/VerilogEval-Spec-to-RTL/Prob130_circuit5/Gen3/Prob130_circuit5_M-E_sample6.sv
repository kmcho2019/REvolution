module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

reg [3:0] f; // assuming 'f' as 4'b1111 (all ones)
assign f = 4'b1111;

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
        q = f;
    end
end

endmodule