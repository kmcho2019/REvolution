module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback = q[0];

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q[31] <= feedback;
            q[30:22] <= q[31:23];
            q[21] <= q[22] ^ feedback; // tap at bit 22 (idx 21)
            q[20:2] <= q[21:3];
            q[1] <= q[2] ^ feedback;   // tap at bit 2 (idx 1)
            q[0] <= q[1] ^ feedback;   // tap at bit 1 (idx 0)
        end
    end

endmodule