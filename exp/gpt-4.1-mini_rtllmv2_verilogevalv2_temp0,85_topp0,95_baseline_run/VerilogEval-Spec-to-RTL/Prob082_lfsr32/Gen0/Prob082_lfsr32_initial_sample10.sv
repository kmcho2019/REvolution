module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions are 32, 22, 2, and 1 (1-based indexing)
    // In Verilog, bit indices are 0-based (0 to 31)
    // So taps are at bit indices 31, 21, 1, and 0
    wire feedback = q[0];

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Next state calculation according to Galois LFSR
            // Shift right: q[i] <= q[i-1] ^ (feedback if tap)
            // q[31] <= q[30] (since no higher bit)
            q[0] <= q[1] ^ (feedback & 1'b1);      // tap at bit 1 (index 0)
            q[1] <= q[2] ^ (feedback & 1'b1);      // tap at bit 2 (index 1)
            q[21] <= q[22] ^ (feedback & 1'b1);    // tap at bit 22 (index 21)
            q[31] <= q[30] ^ (feedback & 1'b1);    // tap at bit 32 (index 31)

            // For bits without taps: q[i] = q[i+1]
            // We'll build a temporary next_q and assign at once
            reg [31:0] next_q;
            integer i;
            // Initialize next_q with shifted values
            for (i = 0; i < 31; i = i + 1)
                next_q[i] = q[i+1];
            next_q[31] = 1'b0; // temporary, will be overwritten below

            // Apply taps XOR with feedback on tapped bits
            // The tapped bits: 31,21,1,0
            next_q[0]  = q[1]  ^ feedback; 
            next_q[1]  = q[2]  ^ feedback;
            next_q[21] = q[22] ^ feedback;
            next_q[31] = q[30] ^ feedback;

            q <= next_q;
        end
    end

endmodule