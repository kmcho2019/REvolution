module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    wire feedback = q[0];  // combinational feedback from LSB

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;  // synchronous reset to non-zero state
        end else begin
            // Galois LFSR right-shift with taps at bits 5 (q[4]) and 3 (q[2])
            q[4] <= feedback;
            q[3] <= q[4];
            q[2] <= q[3] ^ feedback;
            q[1] <= q[2];
            q[0] <= q[1];
        end
    end

endmodule