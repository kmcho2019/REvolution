// Corrected TopModule implementation
module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Initialize output q with a default value to prevent undefined state
initial q = 8'b0; // Initialize q with all zeros

genvar i;
generate
    for (i = 0; i < 8; i++) begin
        always @(posedge clk) begin
            q[i] <= d[i]; // Assign each bit of d to corresponding bit of q
        end
    end
endgenerate

endmodule