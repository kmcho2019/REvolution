module TopModule (
    input in,
    output out
);
    // Modeling a transmission gate (always enabled)
    reg out_reg;
    always @(*) begin
        out_reg = in;  // Acts like NMOS pass transistor
        out_reg = in;  // Acts like PMOS pass transistor (redundant in Verilog but shows concept)
    end
    assign out = out_reg;
endmodule