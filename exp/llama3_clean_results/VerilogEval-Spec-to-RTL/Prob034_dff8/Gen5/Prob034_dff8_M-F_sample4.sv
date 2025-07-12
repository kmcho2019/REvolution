module TopModule(
    input clk,
    input [7:0] d,
    output logic [7:0] q
);

always @(posedge clk) begin
    q <= d; // Using non-blocking assignment for sequential logic
end

// Optional: Initialize q if necessary, depending on the simulation environment's requirements
initial begin
    q = 8'b0; // Initialize q to zero at the start of simulation
end

endmodule