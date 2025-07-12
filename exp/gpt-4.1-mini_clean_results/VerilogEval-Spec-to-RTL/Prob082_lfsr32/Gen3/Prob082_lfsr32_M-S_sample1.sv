module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);
    wire fb = q[0];
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Shift right with taps at 31,21,1,0 applying XOR with feedback
            q[0] <= q[1];
            for (i = 1; i < 32; i = i + 1) begin
                if (i == 31 || i == 21 || i == 1 || i == 0)
                    q[i] <= q[i-1] ^ fb;
                else
                    q[i] <= q[i-1];
            end
        end
    end
endmodule