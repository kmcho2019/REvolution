module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire feedback = q[0];  // Feedback term
wire [31:0] next_q;    // Parallel computation of next state

// Parallel computation of each bit
assign next_q[31] = feedback;
assign next_q[30:22] = q[31:23];
assign next_q[21] = q[22] ^ feedback;
assign next_q[20:2] = q[21:3];
assign next_q[1] = q[2] ^ feedback;
assign next_q[0] = q[1] ^ feedback;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        q <= next_q;  // Parallel update of all bits
    end
end

endmodule