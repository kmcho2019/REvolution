module adder_8bit #(
    parameter WIDTH = 8
)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input Cin,
    input clk_en,    // Clock enable for power gating
    output [WIDTH-1:0] y,
    output Co
);
    // Generate and propagate terms with clock gating
    wire [WIDTH-1:0] g, p;
    assign g = clk_en ? (a & b) : {WIDTH{1'b0}};
    assign p = clk_en ? (a | b) : {WIDTH{1'b0}};
    
    // Kogge-Stone parallel prefix carry computation
    wire [WIDTH:0] c;
    assign c[0] = Cin;
    
    // First stage
    wire [WIDTH-1:1] g1, p1;
    assign g1[1] = g[0] | (p[0] & g[1]);
    assign p1[1] = p[0] & p[1];
    genvar i;
    generate
        for (i = 2; i < WIDTH; i = i+1) begin : stage1
            assign g1[i] = g[i] | (p[i] & g[i-1]);
            assign p1[i] = p[i] & p[i-1];
        end
    endgenerate
    
    // Second stage (skip for WIDTH=8)
    wire [WIDTH-1:3] g2, p2;
    generate
        for (i = 3; i < WIDTH; i = i+2) begin : stage2
            assign g2[i] = g1[i] | (p1[i] & g1[i-2]);
            assign p2[i] = p1[i] & p1[i-2];
        end
    endgenerate
    
    // Final carry computation
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g1[1] | (p1[1] & c[0]);
    generate
        for (i = 3; i <= WIDTH; i = i+1) begin : carry
            if (i % 4 == 3)
                assign c[i] = g1[i-1] | (p1[i-1] & c[(i/4)*4-1]);
            else if (i % 2 == 0)
                assign c[i] = g2[i-1] | (p2[i-1] & c[(i/2)*2-1]);
            else
                assign c[i] = g1[i-1] | (p1[i-1] & c[i-2]);
        end
    endgenerate
    
    // Sum computation
    assign y = a ^ b ^ c[WIDTH-1:0];
    assign Co = c[WIDTH];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    input clk_en,    // Clock enable for power gating
    output [15:0] y,
    output Co
);
    wire carry_middle;
    
    adder_8bit #(.WIDTH(8)) adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .clk_en(clk_en),
        .y(y[7:0]),
        .Co(carry_middle)
    );
    
    adder_8bit #(.WIDTH(8)) adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_middle),
        .clk_en(clk_en),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule