module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Shared combinational XOR wire using behavioral operator for simplicity and efficiency
    wire xor_wire = a ^ b;

    // Continuous assignment output
    assign out_assign = xor_wire;

    // Combinational always block output
    always @(*) begin
        out_always_comb = xor_wire;
    end

    // Sequential always block registers XOR at posedge clk using nonblocking assignment
    always @(posedge clk) begin
        out_always_ff <= xor_wire;
    end

endmodule