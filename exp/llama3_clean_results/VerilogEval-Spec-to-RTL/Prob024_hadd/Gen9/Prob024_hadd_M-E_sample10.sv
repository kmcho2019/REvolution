module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);

always @(*) begin
    case({a, b})
        2'b00: begin sum = 1'b0; cout = 1'b0; end
        2'b01: begin sum = 1'b1; cout = 1'b0; end
        2'b10: begin sum = 1'b1; cout = 1'b0; end
        2'b11: begin sum = 1'b0; cout = 1'b1; end
        default: begin sum = 1'bx; cout = 1'bx; end
    endcase
end

endmodule