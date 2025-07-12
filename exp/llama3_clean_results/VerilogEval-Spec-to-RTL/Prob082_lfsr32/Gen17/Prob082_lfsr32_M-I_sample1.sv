module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

// Combinational logic to calculate the next state of q
always @(*) begin
    // Shift right by default
    q = {q[0] ^ q[21] ^ q[1] ^ q[30], q[31:1]};
end

// Sequential logic to update the state register q
always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 32'h1; // Reset to 1
    end else begin
        // No need for q_next, directly update q
        // This simplification reduces unnecessary logic
    end
end

endmodule