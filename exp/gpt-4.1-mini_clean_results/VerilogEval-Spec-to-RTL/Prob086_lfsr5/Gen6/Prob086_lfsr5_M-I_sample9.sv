module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0];
wire [4:0] next_state;

assign next_state[0] = q[1];
assign next_state[1] = q[2];
assign next_state[2] = q[3] ^ feedback;  // Tap at bit 3 (index 2)
assign next_state[3] = q[4];
assign next_state[4] = feedback;          // Tap at bit 5 (index 4)

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= next_state;
end

endmodule