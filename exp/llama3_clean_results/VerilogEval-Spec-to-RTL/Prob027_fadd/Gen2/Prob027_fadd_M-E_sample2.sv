module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

reg sum, cout;

always @(*) begin
    case ({a, b, cin})
        3'b000: begin sum = 0; cout = 0; end
        3'b001: begin sum = 1; cout = 0; end
        3'b010: begin sum = 1; cout = 0; end
        3'b011: begin sum = 0; cout = 1; end
        3'b100: begin sum = 1; cout = 0; end
        3'b101: begin sum = 0; cout = 1; end
        3'b110: begin sum = 0; cout = 1; end
        3'b111: begin sum = 1; cout = 1; end
    endcase
end

endmodule