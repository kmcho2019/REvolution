module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire [4:0] next_q;

assign next_q = {
    q[0],               // MSB gets LSB (standard shift)
    q[4],               // Next bit gets shifted MSB
    q[3] ^ q[0],        // Tap at position 3 (bit 2)
    q[2],               // Standard shift
    q[1]                // Standard shift
};

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end
    else begin
        q <= next_q;
    end
end

endmodule