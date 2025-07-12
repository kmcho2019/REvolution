// Improved 8-bit full adder module using carry-lookahead approach with optimized logic
module adder_8bit_cla(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    // Calculate generate (g) and propagate (p) signals
    wire [7:0] g, p;
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] | b[0];
    
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] | b[i];
        end
    endgenerate

    // Calculate carry (c) signals using carry-lookahead logic with optimized fan-out
    wire [7:0] c;
    assign c[0] = Cin;
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign c[i] = g[i-1] | (p[i-1] & (i == 1 ? Cin : c[i-2]));
        end
    endgenerate

    // Calculate sum (y) signals
    assign y[0] = a[0] ^ b[0] ^ Cin;
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign y[i] = a[i] ^ b[i] ^ c[i];
        end
    endgenerate

    // Assign carry-out (Co)
    assign Co = g[7] | (p[7] & c[7]);

endmodule

// 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire C1;

    // Instantiate two improved 8-bit adders
    adder_8bit_cla adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(C1)
    );

    adder_8bit_cla adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(C1),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule

// Testbench for the 16-bit full adder
module test_adder_16bit;
    reg [15:0] a, b;
    reg Cin;
    wire [15:0] y;
    wire Co;

    adder_16bit adder(
        .a(a),
        .b(b),
        .Cin(Cin),
        .y(y),
        .Co(Co)
    );

    initial begin
        a = 16'd0;
        b = 16'd0;
        Cin = 1'b0;
        #10;
        $display("a = %h, b = %h, Cin = %b, y = %h, Co = %b", a, b, Cin, y, Co);

        a = 16'd10;
        b = 16'd20;
        Cin = 1'b0;
        #10;
        $display("a = %h, b = %h, Cin = %b, y = %h, Co = %b", a, b, Cin, y, Co);

        a = 16'd65535;
        b = 16'd1;
        Cin = 1'b0;
        #10;
        $display("a = %h, b = %h, Cin = %b, y = %h, Co = %b", a, b, Cin, y, Co);
    end
endmodule