module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback;

assign feedback = q[0] ^ q[2];  // taps at positions 5 (q[4]) and 3 (q[2]) influence feedback; in Galois form, only tap bits XOR q[0], here taps are bits 5 and 3, so feedback = q[0] ^ q[2]

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q <= {q[3:0], feedback};
    end
end

endmodule