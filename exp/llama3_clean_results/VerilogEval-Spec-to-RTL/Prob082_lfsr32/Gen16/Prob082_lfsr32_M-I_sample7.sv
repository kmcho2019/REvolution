module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

reg [31:0] q_next;

// Combinational logic to calculate the feedback term
always @(*) begin
    q_next = {1'b0, q[31:1]}; // Default: shift right
    q_next[31] = q[0] ^ q[21] ^ q[1] ^ q[30]; // Apply taps
end

// Sequential logic to update the state register q
always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 32'h1; // Reset to 1
    end else begin
        q <= q_next; // Update state register
    end
end

endmodule