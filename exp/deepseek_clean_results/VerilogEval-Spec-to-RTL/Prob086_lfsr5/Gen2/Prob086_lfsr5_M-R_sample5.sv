module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire [4:0] next_q;

// Feedback calculation for Galois LFSR with taps at positions 5 and 3
assign next_q[4] = q[0] ^ q[4];  // Position 5
assign next_q[3] = q[4];         // Simple shift
assign next_q[2] = q[0] ^ q[3];  // Position 3 (note: q[3] is original q[4] shifted)
assign next_q[1] = q[2];         // Simple shift
assign next_q[0] = q[1];         // Simple shift

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // Reset to 1
    end
    else begin
        q <= next_q;
    end
end

endmodule