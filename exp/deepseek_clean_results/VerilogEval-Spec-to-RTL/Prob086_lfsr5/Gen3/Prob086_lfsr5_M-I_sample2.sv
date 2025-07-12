module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire [4:0] next_q;

// Correct Galois LFSR feedback logic for polynomial x^5 + x^3 + 1
assign next_q[4] = q[3];
assign next_q[3] = q[2];
assign next_q[2] = q[1] ^ q[0];  // Tap at position 2 (1-based 3)
assign next_q[1] = q[0];
assign next_q[0] = q[4] ^ q[0];  // Tap at position 4 (1-based 5)

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q <= next_q;
    end
end

endmodule