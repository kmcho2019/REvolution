// Define a single D flip-flop module with active high synchronous reset
module DFF(
    input clk,
    input reset,
    input d,
    output q
);

reg q_reg;

always @(negedge clk) begin
    if (reset) begin
        // Reset value is now directly assigned within the module
        // For simplicity and area efficiency, use a constant reset value
        q_reg <= 1'b0; // Changed to a constant for simplicity
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule

// TopModule instantiates 8 DFFs to create an 8-bit register
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Instantiate 8 DFFs with a common reset value
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        DFF u_dff(
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule