module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Initialize 'q' to '4' at the start
initial q = 4;

// Sequential logic to update 'q' at each positive clock edge
always @(posedge clk) begin
    if (a) 
        q <= 4; // Reset to 4 when 'a' is high
    else 
        q <= (q == 6) ? 0 : q + 1; // Increment 'q' and wrap around when 'a' is low
end

endmodule