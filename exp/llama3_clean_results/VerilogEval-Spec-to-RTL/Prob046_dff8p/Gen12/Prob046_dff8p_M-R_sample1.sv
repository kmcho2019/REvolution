// Define a single D flip-flop module with active high synchronous reset
module DFF(
    input clk,
    input reset,
    input d,
    input reset_value, // Programmable reset value
    output reg q
);

always @(negedge clk or posedge reset) begin
    if (reset) begin
        q <= reset_value;
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

// Define the reset value for each DFF
wire [7:0] reset_values = 8'h34;

// Instantiate 8 DFFs
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        DFF u_dff(
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .reset_value(reset_values[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule