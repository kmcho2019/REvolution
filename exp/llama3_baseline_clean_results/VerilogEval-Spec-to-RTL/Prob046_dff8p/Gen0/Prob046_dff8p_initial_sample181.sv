module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   d,
    output  [7:0]   q
);

// Define the reset value as a parameter
parameter RESET_VALUE = 8'h34;

// Use a reg to hold the output of the flip-flops
reg [7:0] q_reg;

// Assign the output of the flip-flops to the output port
assign q = q_reg;

// Always block to describe the flip-flops
always @(posedge ~clk) begin
    if (reset) begin
        // Synchronous reset to the specified value
        q_reg <= RESET_VALUE;
    end else begin
        // Load the input data on the negative edge of the clock
        q_reg <= d;
    end
end

endmodule