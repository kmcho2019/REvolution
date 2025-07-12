module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire [4:0] next_q;

// Galois LFSR feedback logic (taps at positions 4 and 2 in 0-based)
assign next_q[4] = q[3];
assign next_q[3] = q[2] ^ q[0];  // Tap at position 3 (1-based)
assign next_q[2] = q[1];
assign next_q[1] = q[0];
assign next_q[0] = q[4] ^ q[0];  // Tap at position 5 (1-based)

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q <= next_q;
    end
end

endmodule