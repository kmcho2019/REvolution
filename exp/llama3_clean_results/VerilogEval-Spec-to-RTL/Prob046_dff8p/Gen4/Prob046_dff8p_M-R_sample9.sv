module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] data_out;

// Define the reset value as a parameter for clarity and ease of modification
parameter RESET_VALUE = 8'h34;

always @(negedge clk) begin
    if (reset) begin
        // Use the parameter for the reset value
        data_out <= RESET_VALUE;
    end else begin
        data_out <= d;
    end
end

// Assign the output directly from the internal register
assign q = data_out;

endmodule