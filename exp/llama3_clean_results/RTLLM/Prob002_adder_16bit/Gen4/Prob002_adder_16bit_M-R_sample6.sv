// Define the module for a 1-bit full adder (kept for conceptual clarity, but not used directly in the refactored code)
module full_adder(
    input logic a,
    input logic b,
    input logic Cin,
    output logic y,
    output logic Co
);
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// Define the module for a 16-bit full adder using combinational logic
module adder_16bit(
    input logic [15:0] a,
    input logic [15:0] b,
    input logic Cin,
    output logic [15:0] y,
    output logic Co
);

    logic [15:0] carry;

    always_comb begin
        carry[0] = Cin;
        y[0] = a[0] ^ b[0] ^ Cin;
        for (int i = 1; i < 16; i++) begin
            carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
            y[i] = a[i] ^ b[i] ^ carry[i-1];
        end
        Co = carry[15];
    end

endmodule