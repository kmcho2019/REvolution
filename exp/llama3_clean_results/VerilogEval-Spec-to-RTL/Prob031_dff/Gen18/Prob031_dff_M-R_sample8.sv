module TopModule(
    input clk,
    input d,
    output reg q
);

// Initialize q to a default value (e.g., 0) to avoid X during simulation
initial q = 1'b0;

// The always block is triggered on the positive edge of the clock
always @(posedge clk) begin
    // Non-blocking assignment to ensure the new value is assigned at the next clock edge
    q <= d;
end

endmodule