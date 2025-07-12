module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

always @(*) begin
    case ({a, b, c})
        3'b000, 3'b001, 3'b010, 3'b011, 3'b100, 3'b101, 3'b110, 3'b111: begin
            if ((a == 1'b1) || (a == 1'b0 && b == 1'b0 && c == 1'b1)) begin
                out = 1'b1;
            end else begin
                out = 1'b0;
            end
        end
        default: out = 1'bx;
    endcase
end

endmodule