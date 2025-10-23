module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Define the reset value as a parameter for clarity and ease of modification
parameter RESET_VALUE = 8'h34;

reg [7:0] q_reg;

always @(negedge clk) begin
    if (reset) begin
        // Use the parameter for the reset value
        q_reg <= RESET_VALUE;
    end else begin
        q_reg <= d;
    end
end

// Assign the output directly from the internal register
assign q = q_reg;

endmodule