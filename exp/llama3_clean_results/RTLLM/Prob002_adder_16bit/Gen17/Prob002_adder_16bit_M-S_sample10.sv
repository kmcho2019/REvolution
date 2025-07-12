// Define a parameterized module for a full adder of any bit width
module adder_param(
    parameter WIDTH = 16,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input Cin,
    output [WIDTH-1:0] y,
    output Co
);

    // Internal signal for carry
    wire [WIDTH:0] carry;

    // Initialize carry-in
    assign carry[0] = Cin;

    // Generate adder logic for each bit
    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin
            assign y[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate

    // Assign Co
    assign Co = carry[WIDTH];

endmodule

// Instantiate the parameterized adder module for a 16-bit adder
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    adder_param #(.WIDTH(16)) adder(
        .a(a),
        .b(b),
        .Cin(Cin),
        .y(y),
        .Co(Co)
    );

endmodule