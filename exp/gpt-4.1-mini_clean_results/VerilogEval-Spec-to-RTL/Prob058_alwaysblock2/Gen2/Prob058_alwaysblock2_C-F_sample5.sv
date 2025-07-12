module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Shared intermediate combinational XOR signal
    wire xor_comb = a ^ b;

    // Continuous assignment directly from intermediate XOR
    assign out_assign = xor_comb;

    // Combinational always block using always @* to assign out_always_comb
    always @* begin
        out_always_comb = xor_comb;
    end

    // Sequential always block triggered on positive clock edge for registered output
    always @(posedge clk) begin
        out_always_ff <= xor_comb;
    end

endmodule