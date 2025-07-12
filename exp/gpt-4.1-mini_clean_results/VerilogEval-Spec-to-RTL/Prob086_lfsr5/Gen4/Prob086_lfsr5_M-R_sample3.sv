module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

// Compute the feedback bit based on taps at positions 5 (q[4]) and 3 (q[2]) and the output bit q[0]
wire feedback = q[0] ^ q[4] ^ q[2];

// Next state is q shifted right by one with the feedback bit shifted into MSB
wire [4:0] next_q = {feedback, q[4:1]};

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= next_q;
end

endmodule