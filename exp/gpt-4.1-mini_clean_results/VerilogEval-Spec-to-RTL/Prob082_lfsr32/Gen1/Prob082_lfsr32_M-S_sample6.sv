module TopModule(
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else begin
            // feedback is LSB
            wire feedback = q[0];
            q[31] <= q[31] ^ feedback; // tap at bit 32 (q[31])
            q[30:22] <= q[31:23];
            q[21] <= q[21] ^ feedback; // tap at bit 22 (q[21])
            q[20:2] <= q[21:3];
            q[1] <= q[1] ^ feedback;   // tap at bit 2 (q[1])
            q[0] <= q[1] ^ feedback;   // tap at bit 1 (q[0])
        end
    end

endmodule