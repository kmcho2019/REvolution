module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Continuous assignment of XOR to out_assign
    assign out_assign = a ^ b;

    // Intermediate combinational wire driven by always_comb block
    reg xor_comb_wire;

    always @(*) begin
        xor_comb_wire = a ^ b;
    end

    // Combinational always block drives out_always_comb directly with XOR expression
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Sequential always_ff block registers intermediate combinational wire
    always @(posedge clk) begin
        out_always_ff <= xor_comb_wire;
    end

endmodule