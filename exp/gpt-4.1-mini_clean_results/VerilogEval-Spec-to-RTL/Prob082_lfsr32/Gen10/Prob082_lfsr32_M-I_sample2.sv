module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Polynomial taps at positions 32, 22, 2, 1 correspond to bits [31, 21, 1, 0]
    // feedback bit is q[0]
    // Next state computation using Galois LFSR logic

    integer i;
    reg feedback;
    reg [31:0] next_q;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            feedback = q[0];
            next_q[31] = q[31] ^ feedback; // tap at bit 31 (pos 32)
            // bits 30 down to 22 shift right by one without modification except at bit 21 which is a tap
            for (i = 30; i > 21; i = i - 1) begin
                next_q[i] = q[i];
            end
            next_q[21] = q[21] ^ feedback; // tap at bit 21 (pos 22)

            // bits 20 down to 2 shift right by one without modification except bit 1 tap
            for (i = 20; i > 1; i = i - 1) begin
                next_q[i] = q[i];
            end
            next_q[1] = q[1] ^ feedback;   // tap at bit 1 (pos 2)

            // bit 0 shifts right with feedback applied or new bit
            next_q[0] = q[0];  // Actually will be shifted in next clock cycle, but conventionally, shift right means q[0] replaced by q[1], but Galois LFSR usually shifts right and inserts feedback in MSB
            // To do correct shifting right, assign next_q[i] = q[i+1] except for taps
            // Correction of approach below:

            // Let's recode the logic carefully: For a 32-bit Galois LFSR shifting right:
            // For bits i=31 downto 1:
            // if bit i is a tap: next_q[i] = q[i] ^ feedback
            // else next_q[i] = q[i]
            // bit 0 gets q[1]

            // So better to implement like this:
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            feedback = q[0];
            next_q[31] = q[31] ^ feedback; // tap 32
            for (i = 30; i > 21; i = i - 1) begin
                next_q[i] = q[i];
            end
            next_q[21] = q[21] ^ feedback; // tap 22
            for (i = 20; i > 1; i = i -1) begin
                next_q[i] = q[i];
            end
            next_q[1] = q[1] ^ feedback; // tap 2
            next_q[0] = q[0]; // bit 1 taps not yet accounted for; for a shift right, q[0] is replaced by q[1]
            
            // This isn't correct shifting logic; it seems simpler and more correct to implement next state as:

            // For i = 31 downto 1:
            // next_q[i] = q[i-1] ^ (feedback & tap_mask[i])
            // next_q[0] = feedback;

            // Let's implement that for correctness and synthesis friendliness:
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            feedback = q[0];
            next_q[0] = feedback;
            for (i = 1; i < 32; i = i + 1) begin
                // tap mask with bits 31, 21, 1, 0 set:
                // taps at 32,22,2,1 -> bits 31,21,1,0, but bit 0 already handled
                if (i == 31 || i == 21 || i == 1)
                    next_q[i] = q[i-1] ^ feedback;
                else
                    next_q[i] = q[i-1];
            end
            q <= next_q;
        end
    end

endmodule