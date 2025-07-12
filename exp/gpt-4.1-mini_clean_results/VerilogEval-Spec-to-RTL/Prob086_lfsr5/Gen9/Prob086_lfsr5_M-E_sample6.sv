module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback;
assign feedback = q[0] ^ q[2]; // taps at bit 5 (q[4]) and bit 3 (q[2]) use q[0] and q[2] XOR

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q <= {feedback, q[4:1]};
    end
end

endmodule