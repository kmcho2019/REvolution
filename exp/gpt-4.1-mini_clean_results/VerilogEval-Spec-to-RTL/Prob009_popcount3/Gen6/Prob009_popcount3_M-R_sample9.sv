module TopModule (
    input  [2:0] in,
    output reg [1:0] out
);
    reg bit01_and, bit12_and, bit02_and;
    reg parity;

    always @(*) begin
        // Compute pairwise ANDs for majority detection
        bit01_and = in[0] & in[1];
        bit12_and = in[1] & in[2];
        bit02_and = in[0] & in[2];

        // Parity is XOR of all bits
        parity = in[0] ^ in[1] ^ in[2];

        // Assign output bits
        out[0] = parity;
        out[1] = bit01_and | bit12_and | bit02_and;
    end
endmodule