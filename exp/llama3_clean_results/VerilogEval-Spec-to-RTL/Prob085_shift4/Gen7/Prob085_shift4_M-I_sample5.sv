module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

// Use of a reg for the output to ensure it can be used in continuous assignments or procedural assignments
reg [3:0] q_reg;

// Direct assignment of q_reg to output q for simplicity and to avoid unnecessary logic
assign q = q_reg;

// Utilize synthesis directives for area optimization
// Specify the clock period for timing optimization
// For this example, assuming a target clock period of 240 ps as indicated by the eff_clk_period in the PPA metrics
`timescale 1ns/1ps

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero, this operation has the highest priority
        q_reg <= 4'b0000;
    end else begin
        // Use a single if-else statement for conditional operations to minimize logic
        if (load) begin
            // Load data when load is asserted, this operation has higher priority than shift
            q_reg <= data;
        end else if (ena) begin
            // Shift right when ena is asserted and load is not
            q_reg <= {1'b0, q_reg[3:1]};
        end else begin
            // If neither load nor ena is asserted, keep the current state
            q_reg <= q_reg;
        end
    end
end

endmodule