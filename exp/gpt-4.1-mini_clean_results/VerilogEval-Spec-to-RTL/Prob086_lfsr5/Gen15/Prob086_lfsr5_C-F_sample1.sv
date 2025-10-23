module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    wire feedback;
    assign feedback = q[0]; // feedback bit is LSB of current state

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // synchronous reset to a non-zero seed
        end else begin
            // Galois LFSR update with taps at bit 5 (q[4]) and bit 3 (q[2])
            q[0] <= q[1];
            q[1] <= q[2];
            q[2] <= q[3] ^ feedback;
            q[3] <= q[4];
            q[4] <= feedback;
        end
    end

endmodule