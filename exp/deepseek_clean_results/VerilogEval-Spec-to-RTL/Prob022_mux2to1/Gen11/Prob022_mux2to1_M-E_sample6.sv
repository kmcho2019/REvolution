module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // Create a 3-bit address from inputs {a, b, sel}
    wire [2:0] mux_addr = {a, b, sel};
    
    // LUT containing the output for all 8 possible input combinations
    reg [7:0] mux_lut = 8'b01010011;
    // Truth table mapping:
    // addr[2:0] = {a,b,sel} | out
    // 000 (0) -> 1 (sel=0, choose a=0)
    // 001 (1) -> 1 (sel=1, choose b=0)
    // 010 (2) -> 0 (sel=0, choose a=0)
    // 011 (3) -> 0 (sel=1, choose b=1)
    // 100 (4) -> 1 (sel=0, choose a=1)
    // 101 (5) -> 0 (sel=1, choose b=0)
    // 110 (6) -> 1 (sel=0, choose a=1)
    // 111 (7) -> 1 (sel=1, choose b=1)
    
    assign out = mux_lut[mux_addr];
endmodule