module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else begin
        // feedback is q[0] XOR q[2]
        q <= {q[0] ^ q[2], q[4:1]};
    end
end

endmodule