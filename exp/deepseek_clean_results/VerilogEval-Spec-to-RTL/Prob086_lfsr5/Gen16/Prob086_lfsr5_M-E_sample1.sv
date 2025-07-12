module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[4];  // MSB becomes feedback for Fibonacci
wire [4:0] next_q = {q[3:0], 1'b0} ^ {5{feedback}} & 5'b00101;

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= next_q;
end

endmodule