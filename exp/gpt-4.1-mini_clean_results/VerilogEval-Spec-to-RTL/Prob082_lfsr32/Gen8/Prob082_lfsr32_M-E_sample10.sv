module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);
    integer i;
    reg feedback;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            feedback = q[0];
            // Compute next state bit 31 (MSB) with tap at position 32
            q[31] <= q[31] ^ feedback;
            // For bits 30 down to 0
            for (i = 30; i >= 0; i = i -1) begin
                if (i == 21 || i == 1 || i == 0) // taps at 22, 2, 1 (0-based indexing)
                    q[i] <= q[i] ^ feedback;
                else
                    q[i] <= q[i+1];
            end
        end
    end

endmodule