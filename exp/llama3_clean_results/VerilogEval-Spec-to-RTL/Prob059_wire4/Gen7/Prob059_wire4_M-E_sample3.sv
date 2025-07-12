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
        3'b000: begin w = 0; x = 0; y = 0; z = 0; end
        3'b001: begin w = 0; x = 0; y = 0; z = 1; end
        3'b010: begin w = 0; x = 1; y = 1; z = 0; end
        3'b011: begin w = 0; x = 1; y = 1; z = 1; end
        3'b100: begin w = 1; x = 0; y = 0; z = 0; end
        3'b101: begin w = 1; x = 0; y = 0; z = 1; end
        3'b110: begin w = 1; x = 1; y = 1; z = 0; end
        3'b111: begin w = 1; x = 1; y = 1; z = 1; end
        default: begin w = 0; x = 0; y = 0; z = 0; end
    endcase
end

endmodule