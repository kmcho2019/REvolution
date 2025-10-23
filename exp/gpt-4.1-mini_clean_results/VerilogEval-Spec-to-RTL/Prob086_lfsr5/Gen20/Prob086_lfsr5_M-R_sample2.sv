module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

wire feedback;
wire [4:0] next_q;

// feedback is XOR of tap bits and q[0]
assign feedback = q[0] ^ q[2] ^ q[4];

// next state: shift right and insert feedback at MSB
assign next_q = {feedback, q[4:1]};

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q <= next_q;
    end
end

endmodule