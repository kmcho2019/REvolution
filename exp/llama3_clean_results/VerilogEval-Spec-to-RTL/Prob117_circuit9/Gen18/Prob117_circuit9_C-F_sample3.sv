module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Initialize the output
initial q = 4;

// Update the current state at every positive edge of the clock
always @(posedge clk) begin
    if (a) begin
        q <= 4; // Reset to 4 when a is high
    end else begin
        q <= (q < 6) ? q + 1 : 0; // Increment or wrap around when a is low
    end
end

endmodule