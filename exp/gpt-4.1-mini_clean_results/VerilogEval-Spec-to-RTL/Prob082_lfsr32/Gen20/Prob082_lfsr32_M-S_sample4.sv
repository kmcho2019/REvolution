module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);
    integer i;
    wire feedback = q[0];

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q[0] <= q[1];
            for (i = 1; i < 31; i = i + 1) begin
                // Tapped positions: 32, 22, 2, 1 correspond to bits 31, 21, 1, 0 zero-based
                // q[i] = q[i+1] ^ (feedback if tapped)
                if (i == 1 || i == 21 || i == 31)
                    q[i] <= q[i+1] ^ feedback;
                else
                    q[i] <= q[i+1];
            end
            q[31] <= feedback; // Most significant bit gets feedback
        end
    end
endmodule