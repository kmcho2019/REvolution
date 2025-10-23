// Parameterized adder module
module adder #(parameter WIDTH = 16)
(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input Cin,
    output [WIDTH-1:0] y,
    output Co
);

    // Calculate the number of 8-bit adders needed
    localparam NUM_ADDERS = (WIDTH + 7) / 8;

    // Internal wires
    wire [NUM_ADDERS-1:0] carries;

    // Generate the 8-bit adders
    genvar i;
    generate
        for (i = 0; i < NUM_ADDERS; i++) begin
            // Calculate the start and end indices for the current 8-bit adder
            localparam START = i * 8;
            localparam END = (i + 1) * 8 - 1;

            // Instantiate the 8-bit adder
            adder_8bit adder_inst (
               .a(a[END:START]),
               .b(b[END:START]),
               .Cin(i == 0? Cin : carries[i-1]),
               .y(y[END:START]),
               .Co(carries[i])
            );
        end
    endgenerate

    // Assign the carry-out output
    assign Co = carries[NUM_ADDERS-1];

endmodule

// 8-bit full adder module
module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    // Internal wires
    wire [7:0] sum;
    wire [7:0] carry;

    // Calculate the sum and carry for each bit
    assign sum[0] = a[0] ^ b[0] ^ Cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate

    // Assign the output
    assign y = sum;
    assign Co = carry[7];

endmodule

// Example usage
module adder_16bit_example (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    adder #(.WIDTH(16)) adder_inst (
       .a(a),
       .b(b),
       .Cin(Cin),
       .y(y),
       .Co(Co)
    );

endmodule