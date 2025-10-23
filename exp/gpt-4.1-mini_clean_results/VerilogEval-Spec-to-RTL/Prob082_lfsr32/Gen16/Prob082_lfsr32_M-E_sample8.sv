module TopModule (
    input  wire        clk,
    input  wire        reset,
    output reg  [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h0000_0001;
        end else begin
            // Calculate feedback bit q[0]
            wire feedback = q[0];

            q[31] <= q[31] ^ feedback;      // Tap at bit 31
            q[30:22] <= q[31:23];           // Shift bits [30:22]
            q[21] <= q[21] ^ feedback;      // Tap at bit 21
            q[20:2] <= q[21:3];             // Shift bits [20:2]
            q[1] <= q[1] ^ feedback;        // Tap at bit 1
            q[0] <= q[1];                   // Shift bit 1 to bit 0
        end
    end

endmodule