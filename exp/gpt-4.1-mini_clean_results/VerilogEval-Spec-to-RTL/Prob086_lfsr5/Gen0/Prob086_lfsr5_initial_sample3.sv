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
            // tapped bits are 5 and 3 => zero-based bits 4 and 2
            // For Galois LFSR:
            // q[0] <= q[1]
            // q[1] <= q[2]
            // q[2] <= q[3] XOR q[0]
            // q[3] <= q[4]
            // q[4] <= q[0] XOR q[0] (since it's tapped at bit 5, XOR q[0])
            // Actually for bit 4 (tap 5), next is q[0] XOR q[0], which is q[0], but that can't be correct.
            // Actually the rule: For each bit i,
            // if bit i is tapped, then q[i] <= q[i+1] XOR q[0]
            // else q[i] <= q[i+1]
            // The MSB has no q[i+1], so for MSB (bit 4) next is q[0] XOR (tapped)
            // However, since it shifts right, the MSB receives feedback from q[0] XOR q[2] (tap at 5 and 3)
            // So next state logic:
            // temp = q[0]
            // q[4] <= q[0] XOR q[2]
            // q[3] <= q[4]
            // q[2] <= q[3] XOR q[0]
            // q[1] <= q[2]
            // q[0] <= q[1]

            wire feedback = q[0];
            q[0] <= q[1];
            q[1] <= q[2];
            q[2] <= q[3] ^ feedback;
            q[3] <= q[4];
            q[4] <= feedback ^ q[2];
        end
    end

endmodule