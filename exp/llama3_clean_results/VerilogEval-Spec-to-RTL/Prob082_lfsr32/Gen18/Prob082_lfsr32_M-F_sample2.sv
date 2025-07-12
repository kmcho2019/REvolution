module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

// Sequential logic to calculate the next state
always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1; // Reset to 1
    end else begin
        reg [31:0] next_state;
        // Calculate the feedback term
        reg fb = q[31] ^ q[21] ^ q[1] ^ q[0];
        
        // Shift right and apply the feedback term
        next_state = {fb, q[31:1]};
        
        q <= next_state; // Update the state
    end
end

endmodule