module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;

always @(*) begin
    if (a) begin
        next_q = 4; // Reset next_q to 4 when a is high
    end else begin
        next_q = (q == 6) ? 0 : q + 1; // Wrap around to 0 when q reaches 6, else increment q
    end
end

always @(posedge clk) begin
    q <= next_q; // Update q with next_q at every positive clock edge
end

// Initialize the output
initial q = 4;

endmodule