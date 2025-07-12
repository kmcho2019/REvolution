module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
always_comb begin
    case({a, b})
        2'b00: begin sum = 1'b0; cout = 1'b0; end
        2'b01: begin sum = 1'b1; cout = 1'b0; end
        2'b10: begin sum = 1'b1; cout = 1'b0; end
        2'b11: begin sum = 1'b0; cout = 1'b1; end
    endcase
end
endmodule