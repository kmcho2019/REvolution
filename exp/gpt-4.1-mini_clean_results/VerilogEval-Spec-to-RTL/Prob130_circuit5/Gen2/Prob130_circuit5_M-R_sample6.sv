module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

reg [3:0] q_int;

always @(*) begin
    if (c[3:2] == 2'b00) begin // c < 4
        case (c[1:0])
            2'b00: q_int = b;
            2'b01: q_int = e;
            2'b10: q_int = a;
            2'b11: q_int = d;
            default: q_int = 4'h0; // default case, should not occur
        endcase
    end else begin
        q_int = 4'hF;
    end
end

assign q = q_int;

endmodule