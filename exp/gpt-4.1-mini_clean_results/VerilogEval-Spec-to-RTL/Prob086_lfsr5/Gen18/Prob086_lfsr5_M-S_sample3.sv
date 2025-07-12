module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else begin
        // feedback bit is q[0]
        // shift right by one, apply XOR to taps at bits 4 and 2 when feedback=1
        q <= {q[4] ^ q[0], q[4], q[2] ^ q[0], q[2], q[1]};
    end
end

endmodule