module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    input         clk,
    input         en,
    output [99:0] out
);

    reg [99:0] a_reg, b_reg;
    reg sel_reg;
    
    // Clock-gated input registers
    always @(posedge clk) begin
        if (en) begin
            a_reg <= a;
            b_reg <= b;
            sel_reg <= sel;
        end
    end

    // Bitwise mux using generate
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : mux_gen
            assign out[i] = sel_reg ? b_reg[i] : a_reg[i];
        end
    endgenerate

endmodule