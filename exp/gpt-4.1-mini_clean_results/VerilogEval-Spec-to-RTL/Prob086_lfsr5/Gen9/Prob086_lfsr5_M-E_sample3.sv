module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

// Compute feedback bit from current LSB (q[0])
wire feedback = q[0];

// Compute next state combinationally
wire [4:0] next_q;

assign next_q[0] = q[1];
assign next_q[1] = q[2];
assign next_q[2] = q[3] ^ feedback;  // Tap at bit 3
assign next_q[3] = q[4];
assign next_q[4] = feedback;          // Tap at bit 5

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q <= next_q;
    end
end

endmodule