module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire a_sel, b_sel;
    
    // XOR-based selection logic
    assign a_sel = a & ~sel;
    assign b_sel = b & sel;
    assign out = a_sel ^ b_sel;
endmodule