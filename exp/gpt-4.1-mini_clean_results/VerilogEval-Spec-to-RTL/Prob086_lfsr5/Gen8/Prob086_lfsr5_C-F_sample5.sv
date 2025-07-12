module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    reg feedback;

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;  // synchronous reset to 1
        end else begin
            feedback = q[0];
            // Update bits with Galois LFSR right shift and taps at bits 5 and 3
            q[4] <= feedback;           // tap bit 5: XOR with feedback (here just feedback because input q[4] XOR feedback)
            q[3] <= q[4];
            q[2] <= q[3] ^ feedback;    // tap bit 3: XOR with feedback
            q[1] <= q[2];
            q[0] <= q[1];
        end
    end

endmodule