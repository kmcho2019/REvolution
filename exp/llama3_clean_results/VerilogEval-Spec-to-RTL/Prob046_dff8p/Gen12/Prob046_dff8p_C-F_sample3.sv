// Define a single D flip-flop module with active high synchronous reset and programmable reset value
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

// TopModule instantiates 8 DFFs to create an 8-bit register with programmable reset values
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Define the reset value for each DFF
wire [7:0] reset_values = 8'h34;

// Instantiate 8 DFFs with programmable reset values
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        DFF #(.RESET_VALUE(reset_values[i])) u_dff(
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .reset_value(reset_values[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule