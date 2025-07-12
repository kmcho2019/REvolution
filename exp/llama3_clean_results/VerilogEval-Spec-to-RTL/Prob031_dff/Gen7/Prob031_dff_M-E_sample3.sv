module TopModule(
    input clk,
    input d,
    output reg q
);

// Initialize q to a default value for a defined state at startup
initial q = 1'b0;

// Use an always block with a sensitivity list to the positive edge of the clock
always @(posedge clk) begin
    // Update q with the value of d using non-blocking assignment
    q <= d;
end

endmodule