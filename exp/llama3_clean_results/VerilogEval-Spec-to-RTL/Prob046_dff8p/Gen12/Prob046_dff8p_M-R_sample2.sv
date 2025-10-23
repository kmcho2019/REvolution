// Define a single D flip-flop module with active high synchronous reset
module DFF(
    input clk,
    input reset,
    input d,
    output reg q
);

parameter RESET_VALUE = 1'b0; // Default reset value

// Apply clock gating to reduce power consumption
reg clk_gated;
assign clk_gated = clk && !reset;

// Directly assign the output of the DFF
always @(negedge clk_gated) begin
    q <= d;
end

// Reset the DFF on the positive edge of the clock when reset is high
always @(posedge clk) begin
    if (reset) begin
        q <= RESET_VALUE;
    end
end

endmodule

// TopModule instantiates 8 DFFs to create an 8-bit register
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

// Define the reset value as a parameter for clarity and ease of modification
parameter RESET_VALUE = 8'h34;

// Instantiate 8 DFFs with the desired reset value
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