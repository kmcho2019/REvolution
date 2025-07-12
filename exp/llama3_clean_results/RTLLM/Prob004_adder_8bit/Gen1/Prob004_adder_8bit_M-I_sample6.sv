// Parameterized full adder module
module full_adder #(
    parameter WIDTH = 1
)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);

    // Internal wires to connect full adders
    wire [WIDTH-2:0] c;

    // Generate full adders for each bit position
    for (genvar i = 0; i < WIDTH; i++) begin
        if (i == 0) begin
            // First bit full adder
            full_adder_bit fa0(a[0], b[0], cin, sum[0], c[0]);
        end else if (i == WIDTH - 1) begin
            // Last bit full adder
            full_adder_bit fa_last(a[i], b[i], c[i-1], sum[i], cout);
        end else begin
            // Middle bit full adders
            full_adder_bit fa(a[i], b[i], c[i-1], sum[i], c[i]);
        end
    end

endmodule

// Single-bit full adder module
module full_adder_bit(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// 8-bit adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Instantiate the parameterized full adder module
    full_adder #(.WIDTH(8)) fa8(a, b, cin, sum, cout);

endmodule