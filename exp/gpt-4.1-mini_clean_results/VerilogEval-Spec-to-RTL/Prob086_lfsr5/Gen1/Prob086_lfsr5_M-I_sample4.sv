module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // Galois LFSR feedback bit from LSB
            wire feedback = q[0];
            // Compute next state as a whole vector
            // q[4] (bit 5) = q[3] ^ feedback
            // q[3] (bit 4) = q[4]
            // q[2] (bit 3) = q[1] ^ feedback
            // q[1] (bit 2) = q[2]
            // q[0] (bit 1) = q[1]
            q <= { (q[3] ^ feedback), q[4], (q[1] ^ feedback), q[2], q[1] };
        end
    end

endmodule