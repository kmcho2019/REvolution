// Define a single D flip-flop module with active high synchronous reset
module DFF(
    input clk,
    input reset,
    input d,
    parameter RESET_VALUE = 1'b0, // Programmable reset value
    output q
);

reg q_reg;

always @(negedge clk) begin
    if (reset) begin
        q_reg <= RESET_VALUE;
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

// Define the reset value for each DFF
parameter RESET_VALUE = 8'h34;

// Instantiate 8 DFFs
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        DFF #(.RESET_VALUE(RESET_VALUE[i])) u_dff(
           .clk(clk),
           .reset(reset),
           .d(d[i]),
           .q(q[i])
        );
    end
endgenerate

endmodule