module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

// Combinational logic for feedback and taps
wire feedback = q[0];
wire [4:0] next_q = {
    feedback,       // New MSB (position 5)
    q[4],           // Shift position 4 to 3
    q[3] ^ feedback, // Tap at position 3 (XOR with feedback)
    q[2:1]          // Shift positions 2 and 1
};

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q <= next_q;
    end
end

endmodule