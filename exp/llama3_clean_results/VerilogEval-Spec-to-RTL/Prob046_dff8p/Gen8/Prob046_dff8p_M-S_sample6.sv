// Define a single D flip-flop module with active high synchronous reset
module DFF(
    input clk,
    input reset,
    input d,
    output reg q
);

always @(negedge clk) begin
    if (reset) begin
        q <= 1'b0; // We will handle reset value in TopModule
    end else begin
        q <= d;
    end
end

endmodule

// TopModule instantiates 8 DFFs to create an 8-bit register
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] reset_values = 8'h34;

// Instantiate 8 DFFs
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        DFF u_dff(
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(q[i])
        );
        initial q[i] = reset_values[i]; // Set initial value
    end
endgenerate

endmodule