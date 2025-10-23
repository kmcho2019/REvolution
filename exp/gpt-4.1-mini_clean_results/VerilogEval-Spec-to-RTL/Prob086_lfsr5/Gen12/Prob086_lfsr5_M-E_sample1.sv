module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback;
wire [4:0] next_q;

// Calculate feedback as XOR of LSB and tapped bits
assign feedback = q[0] ^ q[4] ^ q[2];

// Next state logic: shift right with feedback on tap positions
assign next_q[0] = feedback;
assign next_q[1] = q[0];
assign next_q[2] = q[1];
assign next_q[3] = q[2];
assign next_q[4] = q[3];

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= next_q;
end

endmodule