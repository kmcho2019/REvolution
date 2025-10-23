module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in;  // Register to store the previous state of the input vector

// Initialize the previous state register to a known value at the start
initial begin
    prev_in = 8'b0;
end

// Sequential logic to update the previous state
always @(posedge clk) begin
    prev_in <= in;  // Update the previous state
end

// Combinational logic to detect edges
always @(posedge clk) begin
    for (int i = 0; i < 8; i++) begin
        if (in[i] != prev_in[i]) begin
            anyedge[i] <= 1'b1;  // Set the output bit if an edge is detected
        end else begin
            anyedge[i] <= 1'b0;  // Clear the output bit if no edge is detected
        end
    end
end

endmodule