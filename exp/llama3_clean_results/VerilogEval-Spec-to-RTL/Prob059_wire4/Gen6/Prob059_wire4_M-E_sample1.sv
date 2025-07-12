module TopModule(
    input  a,
    input  b,
    input  c,
    output reg w,
    output reg x,
    output reg y,
    output reg z
);

always @(*) begin
    case ({a, b, c})
        default: begin
            w = a;
            x = b;
            y = b;
            z = c;
        end
    endcase
end

endmodule