// 8-bit full adder module using carry-lookahead adder architecture
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    
    wire [7:0] sum;
    wire [7:0] carry;
    wire [7:0] p; // propagate signal
    wire [7:0] g; // generate signal
    
    // calculate propagate and generate signals
    assign p[0] = a[0] ^ b[0];
    assign g[0] = a[0] & b[0];
    
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign p[i] = a[i] ^ b[i];
            assign g[i] = a[i] & b[i];
        end
    endgenerate
    
    // calculate carry signals using carry-lookahead adder architecture
    assign carry[0] = g[0] | (p[0] & Cin);
    assign carry[1] = g[1] | (p[1] & (g[0] | (p[0] & Cin)));
    assign carry[2] = g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & Cin)))));
    assign carry[3] = g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & Cin)))))));
    assign carry[4] = g[4] | (p[4] & (g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & Cin))))))));
    assign carry[5] = g[5] | (p[5] & (g[4] | (p[4] & (g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & Cin)))))))));
    assign carry[6] = g[6] | (p[6] & (g[5] | (p[5] & (g[4] | (p[4] & (g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & Cin)))))))));
    assign carry[7] = g[7] | (p[7] & (g[6] | (p[6] & (g[5] | (p[5] & (g[4] | (p[4] & (g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & Cin)))))))))));
    
    // calculate sum signals
    assign sum[0] = a[0] ^ b[0] ^ Cin;
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
        end
    endgenerate
    
    assign y = sum;
    assign Co = carry[7];
endmodule

// 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    
    adder_8bit adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(C1)
    );
    
    adder_8bit adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(C1),
        .y(y[15:8]),
        .Co(Co)
    );
    
    wire C1;
endmodule