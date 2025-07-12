module TopModule(
    input           clk,
    input           reset,
    input   [7:0]    d,
    output  [7:0]    q
);

// Define the reset vector as a parameter
parameter reset_vector = 8'h34;

// Use 8 DFFs, triggered by the negative edge of clk, with active high synchronous reset
reg [7:0] q_reg;

always @(negedge clk) begin
    if (reset) begin
        // Reset q_reg to the reset vector on the negative edge of clk when reset is high
        q_reg <= reset_vector;
    end else begin
        // Load the input d into q_reg on the negative edge of clk when reset is low
        q_reg <= d;
    end
end

// Assign q_reg to output q
assign q = q_reg;

endmodule