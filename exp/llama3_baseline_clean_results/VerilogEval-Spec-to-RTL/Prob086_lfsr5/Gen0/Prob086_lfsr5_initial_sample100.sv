module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] q;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 5'b00001; // reset q to 1, rest to 0
    end else begin
        q[4] <= q[3] ^ q[0]; // MSB gets XOR of current MSB and LSB
        q[3] <= q[2] ^ q[0]; // tap at position 3
        q[2] <= q[1];
        q[1] <= q[0];
    end
end

endmodule