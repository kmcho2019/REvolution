// Define a single D flip-flop module with active high synchronous reset
module DFF(
    input clk,
    input reset,
    input d,
    input reset_value, // Programmable reset value
    output q
);

reg q_reg;

always @(negedge clk) begin
    if (reset) begin
        q_reg <= reset_value;
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

// Instantiate 8 DFFs directly with reset values
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        DFF u_dff(
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .reset_value(8'h34[i]), // Directly specify reset values
            .q(q[i])
        );
    end
endgenerate

endmodule