module TopModule(
    input clk,
    input reset,
    output reg [31:0] q
);

    // feedback bit is q[0]
    wire feedback = q[0];

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else begin
            q <= {
                q[31] ^ feedback, // bit 31 (tap 32)
                q[30:22],
                q[21] ^ feedback, // bit 21 (tap 22)
                q[20:2],
                q[1]  ^ feedback, // bit 1 (tap 2)
                q[0]  ^ feedback  // bit 0 (tap 1)
            };
        end
    end

endmodule