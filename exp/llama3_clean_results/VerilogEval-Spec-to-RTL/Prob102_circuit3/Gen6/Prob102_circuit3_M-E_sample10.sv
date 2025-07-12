module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

reg [1:0] ab;
reg [1:0] cd;
reg lut_q;

always @(a, b) begin
    if (a || b) begin
        ab = 2'b10; // at least one of a or b is 1
    end else begin
        ab = 2'b00; // both a and b are 0
    end
end

always @(c, d) begin
    if (c || d) begin
        cd = 2'b10; // at least one of c or d is 1
    end else begin
        cd = 2'b00; // both c and d are 0
    end
end

always @(ab, cd) begin
    case ({ab, cd})
        4'b0010, 4'b1010, 4'b0110, 4'b1110: lut_q = 1'b1; // if ab is 10 (at least one of a or b is 1) and cd is 10 (at least one of c or d is 1)
        default: lut_q = 1'b0;
    endcase
end

assign q = lut_q;

endmodule