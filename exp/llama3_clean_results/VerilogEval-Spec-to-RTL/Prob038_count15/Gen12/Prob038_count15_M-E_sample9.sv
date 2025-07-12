module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

// Define the LFSR's feedback taps for generating the 4-bit binary counting sequence
// The taps are chosen to produce a maximal-length LFSR sequence that wraps around after 16 states
wire feedback = q[3] ^ q[2] ^ q[0];

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to the initial state (0)
        q <= 4'd0;
    end else begin
        // Shift the LFSR's state and apply the feedback
        q <= {q[2:0], feedback};
    end
end

endmodule