module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions zero-based: 31, 21, 1, 0
    wire feedback = q[0];

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q[0]  <= q[1] ^ feedback;       // bit 1 tapped? Yes, bit 2 tapped -> bit 1 zero-based is tapped
            q[1]  <= q[2];                 // bit 2 is tapped, so q[1] = q[2]^feedback, wait check taps carefully
            q[21] <= q[22] ^ feedback;
            q[31] <= q[31] ^ feedback;
            // Instead of manually assigning bits, implement a loop with the condition

            // We must be precise:
            // For each bit i from 0 to 30:
            // If i is tapped (31,21,1,0), then q[i] = q[i+1] ^ feedback
            // else q[i] = q[i+1]

            // However, q[31] (MSB) does not have q[32], so for bit 31, assign q[31] = feedback if tapped, else 0

            reg [31:0] next_q;

            for (i = 0; i < 31; i = i + 1) begin
                if ( (i == 0) || (i == 1) || (i == 21) || (i == 31) ) begin
                    // taps at bits 0,1,21,31 zero-based, per spec
                    next_q[i] = q[i+1] ^ feedback;
                end else begin
                    next_q[i] = q[i+1];
                end
            end
            // bit 31
            if ( (31 == 0) || (31 == 1) || (31 == 21) || (31 == 31) ) begin
                next_q[31] = feedback;
            end else begin
                next_q[31] = 0;
            end

            q <= next_q;
        end
    end

endmodule