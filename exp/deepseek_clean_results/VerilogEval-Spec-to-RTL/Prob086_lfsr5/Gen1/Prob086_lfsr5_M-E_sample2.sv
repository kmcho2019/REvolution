module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0];  // Common feedback term

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        // Explicit handling of each bit
        q[4] <= q[4] ^ feedback;    // Tap at position 5
        q[3] <= q[4];              // Regular shift
        q[2] <= q[3] ^ feedback;    // Tap at position 3
        q[1] <= q[2];               // Regular shift
        q[0] <= q[1];               // Regular shift
    end
end

endmodule