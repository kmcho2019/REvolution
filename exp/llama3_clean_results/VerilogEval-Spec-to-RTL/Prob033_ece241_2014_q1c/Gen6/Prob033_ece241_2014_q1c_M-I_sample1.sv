module TopModule(
    input  [7:0] a,  // 8-bit 2's complement input number
    input  [7:0] b,  // 8-bit 2's complement input number
    output [7:0] s,  // 8-bit result of the addition
    output      overflow  // indicator of signed overflow
);

    // Internal wires for the carry-lookahead adder
    wire [7:0] sum;
    wire [7:0] carry_out;
    wire [7:0] generate;
    wire [7:0] propagate;
    wire        carry_in;
    wire        overflow;

    // Initialize the carry-in for the LSB
    assign carry_in = 1'b0;

    // Generate and propagate signals for each bit position
    assign generate[0] = a[0] & b[0];
    assign propagate[0] = a[0] | b[0];

    // For bits 1 to 7
    generate_and_propagate gen_prop(
       .a(a[1:7]),
       .b(b[1:7]),
       .generate(generate[1:7]),
       .propagate(propagate[1:7])
    );

    // Calculate the carry signals
    carry_lookahead cla(
       .generate(generate),
       .propagate(propagate),
       .carry_in(carry_in),
       .carry_out(carry_out)
    );

    // Sum calculation
    assign sum[0] = a[0] ^ b[0] ^ carry_in;

    // For bits 1 to 7
    sum_calculation sum_calc(
       .a(a[1:7]),
       .b(b[1:7]),
       .carry_in(carry_out[0:6]),
       .sum(sum[1:7])
    );

    // Assign the result of the addition
    assign s = sum;

    // Detect signed overflow
    assign overflow = (a[7] == b[7] && a[7]!= s[7]);

endmodule

// Generate and propagate module
module generate_and_propagate(
    input  [6:0] a,
    input  [6:0] b,
    output [6:0] generate,
    output [6:0] propagate
);

    // Generate and propagate signals for each bit position
    assign generate[0] = a[0] & b[0];
    assign propagate[0] = a[0] | b[0];

    // For bits 1 to 6
    for (genvar i = 1; i < 7; i++) begin
        assign generate[i] = a[i] & b[i];
        assign propagate[i] = a[i] | b[i];
    end

endmodule

// Carry-lookahead module
module carry_lookahead(
    input  [7:0] generate,
    input  [7:0] propagate,
    input        carry_in,
    output [7:0] carry_out
);

    // Calculate the carry signals
    assign carry_out[0] = generate[0] | (propagate[0] & carry_in);
    for (genvar i = 1; i < 8; i++) begin
        assign carry_out[i] = generate[i] | (propagate[i] & carry_out[i-1]);
    end

endmodule

// Sum calculation module
module sum_calculation(
    input  [6:0] a,
    input  [6:0] b,
    input  [6:0] carry_in,
    output [6:0] sum
);

    // Sum calculation
    assign sum[0] = a[0] ^ b[0] ^ carry_in[0];
    for (genvar i = 1; i < 7; i++) begin
        assign sum[i] = a[i] ^ b[i] ^ carry_in[i-1];
    end

endmodule