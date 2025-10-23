module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    reg comb_xor;          // Registered intermediate XOR for combinational output
    wire comb_xor_wire;    // Combinational XOR result wire

    // Combinational always block computes XOR into comb_xor register asynchronously
    always @(*) begin
        comb_xor = a ^ b;
    end

    // Assign output directly wired to combinational XOR wire (no register)
    assign comb_xor_wire = a ^ b;
    assign out_assign = comb_xor_wire;

    // out_always_comb driven from registered comb_xor (introducing minimal delay)
    always @(*) begin
        out_always_comb = comb_xor;
    end

    // Sequential always block registers XOR result on posedge clk
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule