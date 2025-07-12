module TopModule (
    input wire clk,
    input wire reset,
    output reg [4:0] q
);

wire fb = q[0]; // feedback bit

// Compute next state bits based on taps at q[4] and q[2] XORed with feedback
wire [4:0] next_q;
assign next_q[4] = fb;
assign next_q[3] = q[4] ^ fb;
assign next_q[2] = q[3];
assign next_q[1] = q[2] ^ fb;
assign next_q[0] = q[1];

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q <= next_q;
    end
end

endmodule