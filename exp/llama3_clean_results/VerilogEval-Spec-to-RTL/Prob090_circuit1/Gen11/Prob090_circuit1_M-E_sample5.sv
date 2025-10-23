module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

logic [1:0] addr;
assign addr = {a, b};

always_comb begin
    case (addr)
        2'b00: q = 0;
        2'b01: q = 0;
        2'b10: q = 0;
        2'b11: q = 1;
        default: q = 0; // This should never occur for 2-bit addr
    endcase
end

endmodule