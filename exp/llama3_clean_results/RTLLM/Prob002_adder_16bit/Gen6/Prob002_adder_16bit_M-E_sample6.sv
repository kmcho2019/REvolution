// 4-bit full adder module
module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);
    
    wire [3:0] sum;
    wire [3:0] carry;
    
    // Calculate sum and carry for each bit
    assign sum[0] = a[0] ^ b[0] ^ Cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);
    
    // For bits 1 to 3
    generate
        for (genvar i = 1; i < 4; i++) begin
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate
    
    // Assign output
    assign y = sum;
    assign Co = carry[3];
endmodule

// Carry propagation module
module carry_prop(
    input C0, C1, C2, C3, // Carry-ins from 4-bit adders
    input Cin, // Global carry-in
    output Co // Global carry-out
);
    
    // Calculate global carry-out using a tree-like structure
    wire C01, C23;
    assign C01 = C0 | C1;
    assign C23 = C2 | C3;
    assign Co = (Cin & (C01 | C23)) | (C01 & C23);
endmodule

// 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    
    wire C1, C2, C3; // Carry-outs from 4-bit adders
    
    // Instantiate four 4-bit adders
    adder_4bit adder_0(
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(C1)
    );
    
    adder_4bit adder_1(
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(C1),
        .y(y[7:4]),
        .Co(C2)
    );
    
    adder_4bit adder_2(
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(C2),
        .y(y[11:8]),
        .Co(C3)
    );
    
    adder_4bit adder_3(
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(C3),
        .y(y[15:12]),
        .Co(Co)
    );
    
    // No need for carry_prop module as we directly connect carry-outs
    // assign Co = carry_prop(C1, C2, C3, Cin);
endmodule