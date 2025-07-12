module TopModule (
    input clk,
    input in,
    output out
);

    reg d_reg = 1'b0;  // Explicit initialization
    wire xor_to_d;
    wire d_to_xor;

    // Feedback path: output connects back to XOR
    assign d_to_xor = d_reg;
    assign out = d_reg;

    // Combinational XOR logic
    assign xor_to_d = in ^ d_to_xor;

    // Sequential logic with explicit non-blocking assignment
    always @(posedge clk) begin
        d_reg <= xor_to_d;
    end

endmodule