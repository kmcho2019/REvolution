module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
    // input clk,        // Uncomment for synchronous version
    // input enable      // Uncomment for synchronous version
);

    // Zero input detection
    wire zero_A = (A == 8'b0);
    wire zero_B = (B == 8'b0);
    
    // Generate all 8 partial products with operand isolation
    wire [15:0] pp0 = zero_B ? 16'b0 : ({{8{1'b0}}, A} & {16{B[0]}});
    wire [15:0] pp1 = zero_B ? 16'b0 : ({{7{1'b0}}, A, 1'b0} & {16{B[1]}});
    wire [15:0] pp2 = zero_B ? 16'b0 : ({{6{1'b0}}, A, 2'b0} & {16{B[2]}});
    wire [15:0] pp3 = zero_B ? 16'b0 : ({{5{1'b0}}, A, 3'b0} & {16{B[3]}});
    wire [15:0] pp4 = zero_B ? 16'b0 : ({{4{1'b0}}, A, 4'b0} & {16{B[4]}});
    wire [15:0] pp5 = zero_B ? 16'b0 : ({{3{1'b0}}, A, 5'b0} & {16{B[5]}});
    wire [15:0] pp6 = zero_B ? 16'b0 : ({{2{1'b0}}, A, 6'b0} & {16{B[6]}});
    wire [15:0] pp7 = zero_B ? 16'b0 : ({{1{1'b0}}, A, 7'b0} & {16{B[7]}});

    // Carry-save adder reduction tree
    wire [15:0] s1, c1;
    wire [15:0] s2, c2;
    wire [15:0] s3, c3;
    
    // First level: 4 CSAs
    csa #(.WIDTH(16)) csa1(.a(pp0), .b(pp1), .cin(pp2), .sum(s1), .cout(c1));
    csa #(.WIDTH(16)) csa2(.a(pp3), .b(pp4), .cin(pp5), .sum(s2), .cout(c2));
    
    // Second level: 1 CSA for remaining terms
    csa #(.WIDTH(16)) csa3(.a(pp6), .b(pp7), .cin(16'b0), .sum(s3), .cout(c3));
    
    // Final adder (CPA)
    wire [15:0] sum_intermediate = s1 + s2 + s3;
    wire [15:0] carry_intermediate = {c1[14:0],1'b0} + {c2[14:0],1'b0} + {c3[14:0],1'b0};
    
    // For synchronous implementation:
    // reg [15:0] product_reg;
    // always @(posedge clk) begin
    //     if (enable) begin
    //         product_reg <= sum_intermediate + carry_intermediate;
    //     end
    // end
    // assign product = product_reg;
    
    // For combinational implementation:
    assign product = zero_A || zero_B ? 16'b0 : (sum_intermediate + carry_intermediate);

endmodule

// Carry-Save Adder module
module csa #(
    parameter WIDTH = 16
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [WIDTH-1:0] cin,
    output [WIDTH-1:0] sum,
    output [WIDTH-1:0] cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule