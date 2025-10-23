module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

wire feedback;
assign feedback = q[0] ^ q[2] ^ q[4]; // taps at bit 5 (q[4]) and bit 3 (q[2]) XORed with q[0]

wire [4:0] next_q;
assign next_q = {feedback, q[4:1]};

always @(posedge clk) begin
    if (reset) 
        q <= 5'b00001;
    else 
        q <= next_q;
end

endmodule