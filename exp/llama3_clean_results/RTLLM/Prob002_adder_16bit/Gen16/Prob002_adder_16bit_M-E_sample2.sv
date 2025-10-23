// Define the module for a full adder cell
module full_adder(
    input a,
    input b,
    input Cin,
    output Sum,
    output Cout
);
    assign Sum = a ^ b ^ Cin;
    assign Cout = (a & b) | (a & Cin) | (b & Cin);
endmodule

// Define the module for a 4-bit adder
module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);
    wire [3:0] carry;

    // First bit (bit 0) adder
    full_adder fa0(
       .a(a[0]),
       .b(b[0]),
       .Cin(Cin),
       .Sum(y[0]),
       .Cout(carry[0])
    );

    // Bits 1 to 3 adders
    genvar i;
    generate
        for (i = 1; i < 4; i++) begin
            full_adder fa(
               .a(a[i]),
               .b(b[i]),
               .Cin(carry[i-1]),
               .Sum(y[i]),
               .Cout(carry[i])
            );
        end
    endgenerate

    // Assign Co
    assign Co = carry[3];
endmodule

// Define the module for a 16-bit full adder using 4-bit adders and carry-save adder approach
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire C1, C2, C3;

    // Instantiate the least significant 4-bit adder
    adder_4bit adder_ls(
       .a(a[3:0]),
       .b(b[3:0]),
       .Cin(Cin),
       .y(y[3:0]),
       .Co(C1)
    );

    // Instantiate the second 4-bit adder
    adder_4bit adder_2(
       .a(a[7:4]),
       .b(b[7:4]),
       .Cin(C1),
       .y(y[7:4]),
       .Co(C2)
    );

    // Instantiate the third 4-bit adder
    adder_4bit adder_3(
       .a(a[11:8]),
       .b(b[11:8]),
       .Cin(C2),
       .y(y[11:8]),
       .Co(C3)
    );

    // Instantiate the most significant 4-bit adder
    adder_4bit adder_ms(
       .a(a[15:12]),
       .b(b[15:12]),
       .Cin(C3),
       .y(y[15:12]),
       .Co(Co)
    );
endmodule

// Define a testbench for the 16-bit full adder
module tb_adder_16bit;
reg [15:0] a;
reg [15:0] b;
reg Cin;
wire [15:0] y;
wire Co;

adder_16bit uut(
   .a(a),
   .b(b),
   .Cin(Cin),
   .y(y),
   .Co(Co)
);

initial begin
    a = 16'd1;
    b = 16'd2;
    Cin = 1'b0;
    #10;
    $display("a = %h, b = %h, Cin = %b, y = %h, Co = %b", a, b, Cin, y, Co);
    a = 16'd10;
    b = 16'd20;
    Cin = 1'b1;
    #10;
    $display("a = %h, b = %h, Cin = %b, y = %h, Co = %b", a, b, Cin, y, Co);
    $finish;
end

endmodule