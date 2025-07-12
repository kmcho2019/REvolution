module TopModule(
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else begin
            wire feedback = q[0];
            q <= { (q[31] ^ feedback), q[30:22], (q[21] ^ feedback), q[20:2], (q[1] ^ feedback), (q[0] ^ feedback) };
        end
    end

endmodule