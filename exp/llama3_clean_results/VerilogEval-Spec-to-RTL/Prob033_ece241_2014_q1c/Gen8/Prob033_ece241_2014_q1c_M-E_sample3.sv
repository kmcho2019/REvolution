module TopModule(
    input  [7:0] a,  // 8-bit 2's complement input number
    input  [7:0] b,  // 8-bit 2's complement input number
    output [7:0] s,  // 8-bit result of the addition
    output      overflow  // indicator of signed overflow
);

    // Define the carry bits for the addition
    wire [7:0] carry;

    // Pre-calculate the carry bits for the addition
    assign carry[0] = a[0] & b[0];
    assign carry[1] = (a[1] & b[1]) | (a[1] & carry[0]) | (b[1] & carry[0]);
    assign carry[2] = (a[2] & b[2]) | (a[2] & carry[1]) | (b[2] & carry[1]);
    assign carry[3] = (a[3] & b[3]) | (a[3] & carry[2]) | (b[3] & carry[2]);
    assign carry[4] = (a[4] & b[4]) | (a[4] & carry[3]) | (b[4] & carry[3]);
    assign carry[5] = (a[5] & b[5]) | (a[5] & carry[4]) | (b[5] & carry[4]);
    assign carry[6] = (a[6] & b[6]) | (a[6] & carry[5]) | (b[6] & carry[5]);
    assign carry[7] = (a[7] & b[7]) | (a[7] & carry[6]) | (b[7] & carry[6]);

    // Perform the addition using the pre-calculated carry bits
    assign s[0] = a[0] ^ b[0] ^ carry[0];
    assign s[1] = a[1] ^ b[1] ^ carry[1];
    assign s[2] = a[2] ^ b[2] ^ carry[2];
    assign s[3] = a[3] ^ b[3] ^ carry[3];
    assign s[4] = a[4] ^ b[4] ^ carry[4];
    assign s[5] = a[5] ^ b[5] ^ carry[5];
    assign s[6] = a[6] ^ b[6] ^ carry[6];
    assign s[7] = a[7] ^ b[7] ^ carry[7];

    // Detect signed overflow using a latch-based circuit
    reg overflow_latch;
    always @(posedge carry[7] or negedge carry[7]) begin
        if (a[7] == b[7] && a[7]!= s[7]) begin
            overflow_latch <= 1'b1;
        end else begin
            overflow_latch <= 1'b0;
        end
    end

    // Output the detected overflow condition
    assign overflow = overflow_latch;

endmodule