module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       overflow;
    wire [4:0] corrected_sum;

    // Step 1: Binary addition of inputs with carry-in
    assign raw_sum = A + B + Cin;

    // Step 2: Overflow detection using simplified logic (raw_sum > 9)
    // Overflow if MSB of raw_sum is 1 or if bit3=1 and (bit2=1 or bit1=1)
    assign overflow = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Add correction 6 (0110) if overflow detected; else use raw_sum directly
    assign corrected_sum = overflow ? (raw_sum[3:0] + 4'd6) + (raw_sum[4] << 4) : raw_sum;

    // Step 4: Assign Sum and Cout outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule