// TopModule implementing a half adder using a lookup table
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
always @(*) begin
    case({a, b})
        2'b00: {sum, cout} = 2'b00;
        2'b01: {sum, cout} = 2'b01;
        2'b10: {sum, cout} = 2'b01;
        2'b11: {sum, cout} = 2'b10;
    endcase
end
endmodule