module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

always_comb begin
    reg [3:0] src;
    reg override;

    override = (c[3:2] != 2'b00);

    case (c[1:0])
        2'b00: src = b;
        2'b01: src = e;
        2'b10: src = a;
        2'b11: src = d;
    endcase

    if (override || (c[1:0] == 2'b11 && c > 4'd3)) begin
        q = 4'b1111;
    end else if (c == {2'b00, c[1:0]}) begin
        q = src;
    end else begin
        q = src;
    end
end

endmodule