// Define the module for a 16-bit full adder using ripple-carry
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Internal signals for carry
    wire [15:0] c;

    // Initialize carry signal
    assign c[0] = Cin;

    // Calculate output and carry for each bit
    generate
        for (genvar i = 0; i < 16; i++) begin
            if (i == 0) begin
                assign y[i] = a[i] ^ b[i] ^ c[i];
                assign c[i+1] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
            end else if (i < 15) begin
                assign y[i] = a[i] ^ b[i] ^ c[i];
                assign c[i+1] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
            end else begin
                assign y[i] = a[i] ^ b[i] ^ c[i];
                assign Co = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
            end
        end
    endgenerate

endmodule