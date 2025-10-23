module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback;
wire [4:0] next_q;

// Feedback is XOR of q[0] (LSB) and q[2] (tap at bit 3)
assign feedback = q[0] ^ q[2];

// Compute next state vector by shifting right with feedback applied to MSB
assign next_q = {feedback, q[4:1]};

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= next_q;
end

endmodule