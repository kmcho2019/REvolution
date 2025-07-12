module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

reg xor_result;

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end
    else begin
        xor_result <= q[3] ^ q[0];
        q <= {q[0], q[4], xor_result, q[2], q[1]};
    end
end

endmodule