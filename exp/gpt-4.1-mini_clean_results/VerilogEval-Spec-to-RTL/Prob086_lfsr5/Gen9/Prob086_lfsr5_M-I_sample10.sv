module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    wire feedback = q[0]; // output bit before shift (LSB)

    always @(posedge clk) begin
        if (reset)
            q <= 5'b00001;
        else begin
            q[4] <= feedback;                 // bit 5 gets feedback directly
            q[3] <= q[4];
            q[2] <= q[3] ^ feedback;          // tap at bit 3 XOR feedback
            q[1] <= q[2];
            q[0] <= q[1];
        end
    end

endmodule