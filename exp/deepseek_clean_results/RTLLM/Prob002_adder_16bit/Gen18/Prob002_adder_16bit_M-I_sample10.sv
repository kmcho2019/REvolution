module adder_4bit_cla (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output g_group,
    output p_group
);
    wire [3:0] g = a & b;
    wire [3:0] p = a | b;
    
    // Carry lookahead calculation
    wire [4:0] c;
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    
    // Group propagate/generate
    assign g_group = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign p_group = &p;
    
    // Sum calculation
    assign sum = a ^ b ^ c[3:0];
endmodule

module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire g_low, p_low, g_high, p_high;
    wire carry_middle;
    
    // Lower 4-bit CLA
    adder_4bit_cla low (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .g_group(g_low),
        .p_group(p_low)
    );
    
    // Middle carry
    assign carry_middle = g_low | (p_low & cin);
    
    // Upper 4-bit CLA
    adder_4bit_cla high (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(carry_middle),
        .sum(sum[7:4]),
        .g_group(g_high),
        .p_group(p_high)
    );
    
    // Final carry
    assign cout = g_high | (p_high & carry_middle);
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Optional pipeline register (parameterized)
    parameter PIPELINE = 0;
    
    wire carry_middle;
    wire [15:0] sum_unreg;
    
    // Lower 8-bit adder
    adder_8bit adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(sum_unreg[7:0]),
        .cout(carry_middle)
    );
    
    // Upper 8-bit adder
    adder_8bit adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_middle),
        .sum(sum_unreg[15:8]),
        .cout(Co)
    );
    
    // Optional pipeline register
    generate
        if (PIPELINE) begin
            reg [15:0] sum_reg;
            always @(posedge clk) begin
                sum_reg <= sum_unreg;
            end
            assign y = sum_reg;
        end else begin
            assign y = sum_unreg;
        end
    endgenerate
endmodule