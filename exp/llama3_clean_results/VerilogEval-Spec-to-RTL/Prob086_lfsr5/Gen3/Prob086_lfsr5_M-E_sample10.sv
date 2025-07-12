module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 1; // Reset LFSR output to 1
    end else begin
        // Calculate next state based on current state and taps
        q <= {q[3] ^ q[0], q[2] ^ q[0], q[1], q[0], q[4]};
    end
end

endmodule