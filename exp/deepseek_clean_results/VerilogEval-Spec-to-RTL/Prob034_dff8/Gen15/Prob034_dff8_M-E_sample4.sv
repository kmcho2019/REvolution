module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Internal register with reset capability
reg [7:0] reg_data;

// Main register process
always @(posedge clk) begin
    // Parallel load (always enabled in this implementation)
    reg_data <= d;
end

// Continuous output assignment
assign q = reg_data;

endmodule