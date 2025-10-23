// 1-bit full adder module
module adder_1bit(
    input a,
    input b,
    input Cin,
    output y,
    output Co
);
    
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// 4-bit full adder module
module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);
    
    wire [2:0] carry;
    
    // Calculate sum and carry for each bit
    adder_1bit adder_0(
        .a(a[0]),
        .b(b[0]),
        .Cin(Cin),
        .y(y[0]),
        .Co(carry[0])
    );
    
    generate
        for (genvar i = 1; i < 4; i++) begin
            adder_1bit adder_i(
                .a(a[i]),
                .b(b[i]),
                .Cin(carry[i-1]),
                .y(y[i]),
                .Co(carry[i])
            );
        end
    endgenerate
    
    // Assign output
    assign Co = carry[3];
endmodule

// 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    
    wire C1, C2, C3;
    
    // Instantiate four 4-bit adders
    adder_4bit adder_lower(
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(C1)
    );
    
    adder_4bit adder_4to7(
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(C1),
        .y(y[7:4]),
        .Co(C2)
    );
    
    adder_4bit adder_8to11(
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(C2),
        .y(y[11:8]),
        .Co(C3)
    );
    
    adder_4bit adder_upper(
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(C3),
        .y(y[15:12]),
        .Co(Co)
    );
endmodule