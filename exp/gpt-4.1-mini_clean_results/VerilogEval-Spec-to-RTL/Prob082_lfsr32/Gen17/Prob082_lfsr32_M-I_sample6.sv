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
            // Shift right with feedback XORed at tap positions
            q[31] <= feedback;
            for (i = 30; i >= 0; i = i -1) begin
                // taps at bits 22, 2, 1 (zero-based 21,1,0)
                if (i == 21 || i == 1 || i == 0)
                    q[i] <= q[i+1] ^ feedback;
                else
                    q[i] <= q[i+1];
            end
        end
    end

endmodule