module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    wire carry0, carry1, carry2, carry3;

    // Generate carry from bit 0
    assign carry0 = (q[0] == 1'b1);

    // Generate carry from bit 1, only if bit 0 was 1 and bit 1 is 1
    assign carry1 = carry0 & (q[1] == 1'b1);

    // Generate carry from bit 2, only if bits 0 and 1 were both 1 and bit 2 is 1
    assign carry2 = carry1 & (q[2] == 1'b1);

    // Generate carry from bit 3, only if bits 0,1,2 were all 1 and bit 3 is 1
    assign carry3 = carry2 & (q[3] == 1'b1);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd0;
        end else if (q == 4'd9) begin
            q <= 4'd0;  // reset to zero after 9
        end else begin
            // ripple increment each bit
            q[0] <= ~q[0];
            q[1] <= q[1] ^ carry0;
            q[2] <= q[2] ^ carry1;
            q[3] <= q[3] ^ carry2;
        end
    end

endmodule