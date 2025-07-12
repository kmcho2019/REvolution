module TopModule(
    input clk,
    input d,
    output reg q
);

// Initialize q to a default value, if necessary
initial q = 1'b0;

// Use an always block with a sensitivity list to the positive edge of the clock
always @(posedge clk) begin
    // Use non-blocking assignment to update q
    q <= d;
end

endmodule