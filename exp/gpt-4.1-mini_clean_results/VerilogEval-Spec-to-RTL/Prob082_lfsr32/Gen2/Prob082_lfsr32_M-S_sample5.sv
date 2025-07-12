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
            // shift right by 1
            // feedback XORed into tapped bits
            q <= {
                q[31] ^ feedback,   // bit 31 (tap 32)
                q[30:22],
                q[21] ^ feedback,   // bit 21 (tap 22)
                q[20:2],
                q[1]  ^ feedback,   // bit 1 (tap 2)
                q[0]  ^ feedback    // bit 0 (tap 1)
            };
        end
    end

endmodule