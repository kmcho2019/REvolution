module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Define taps positions: bits 31,21,1,0 (0-based)
    // Taps array: bit position -> whether tapped (1) or not (0)
    // We implement taps at bits 31, 21, 1, 0 for the next state generation.
    // q[0] is the feedback bit.

    wire feedback = q[0];

    integer i;
    reg [31:0] next_q;

    always @(*) begin
        // Bit 31 (MSB) next: feedback XOR q[31]
        // For bits with taps, next bit = q[i+1] XOR feedback
        // For bits without taps, next bit = q[i+1]
        for (i = 0; i < 31; i = i + 1) begin
            case (i)
                0, 1, 21, 31: begin
                    // Actually taps are at bits 31,21,1,0
                    // Since we shift right, each bit i gets next from q[i+1]
                    // If i+1 is tapped, next bit is q[i+1] XOR feedback
                    // Here we map tap on position i+1, so bits 1,2,22,32
                    // but 32 is out of range, so tap at bit 31 (0-based)
                    // So taps at bits 31,21,1,0 correspond to q[31],q[21],q[1],q[0]
                    // So bits 0,1,21,31 are where the tap XOR occurs on next state:
                    if ((i + 1) == 31 || (i + 1) == 21 || (i + 1) == 1 || (i + 1) == 0) begin
                        next_q[i] = q[i+1] ^ feedback;
                    end else begin
                        next_q[i] = q[i+1];
                    end
                end
                default: begin
                    // Not tapped bit positions
                    if ((i + 1) == 31 || (i + 1) == 21 || (i + 1) == 1 || (i + 1) == 0) begin
                        next_q[i] = q[i+1] ^ feedback;
                    end else begin
                        next_q[i] = q[i+1];
                    end
                end
            endcase
        end
        // MSB bit 31 next: feedback only (since q[32] doesn't exist)
        next_q[31] = feedback;
    end

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_q;
        end
    end

endmodule