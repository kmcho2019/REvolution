module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Registered inputs to reduce glitching
    reg [99:0] a_reg, b_reg;
    reg sel_reg;
    
    always @(*) begin
        a_reg = a;
        b_reg = b;
        sel_reg = sel;
    end

    // Bitwise mux implementation
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : mux_gen
            assign out[i] = sel_reg ? b_reg[i] : a_reg[i];
        end
    endgenerate

endmodule