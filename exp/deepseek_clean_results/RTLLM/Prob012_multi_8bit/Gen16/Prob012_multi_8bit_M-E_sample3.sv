module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    // Radix-4 Booth Encoding
    wire [8:0] B_ext = {B, 1'b0};
    wire [2:0] booth_sel [3:0];
    wire [8:0] booth_pp [3:0];
    wire [15:0] pp [3:0];
    
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : booth
            // Booth encoding
            assign booth_sel[i] = B_ext[2*i+2:2*i];
            
            // Partial product generation
            always @(*) begin
                case (booth_sel[i])
                    3'b000, 3'b111: booth_pp[i] = 9'b0;
                    3'b001, 3'b010: booth_pp[i] = {A[7], A};
                    3'b011:         booth_pp[i] = {A, 1'b0};
                    3'b100:         booth_pp[i] = ~{A, 1'b0} + 1;
                    3'b101, 3'b110: booth_pp[i] = ~{A[7], A} + 1;
                endcase
            end
            
            // Shift and sign extend
            assign pp[i] = $signed(booth_pp[i]) << (2*i);
        end
    endgenerate

    // Asymmetric CSA Tree
    // Lower 8 bits: Simple ripple adder (less critical)
    wire [7:0] sum_low = pp[0][7:0] + pp[1][7:0] + pp[2][7:0] + pp[3][7:0];
    
    // Upper 8 bits: CSA tree
    wire [15:8] sum1, carry1;
    csa_8bit upper_csa1 (
        .a(pp[0][15:8]),
        .b(pp[1][15:8]),
        .c(pp[2][15:8]),
        .sum(sum1),
        .carry(carry1)
    );
    
    wire [15:8] sum2, carry2;
    csa_8bit upper_csa2 (
        .a(sum1),
        .b(carry1),
        .c(pp[3][15:8]),
        .sum(sum2),
        .carry(carry2)
    );
    
    // Segmented Final Adder
    wire [15:8] upper_sum;
    wire cout;
    
    // Lower 4 bits of upper byte use ripple
    assign upper_sum[11:8] = sum2[11:8] + carry2[10:7] + sum_low[8];
    
    // Upper 4 bits use carry-lookahead
    cla_4bit upper_adder (
        .a(sum2[15:12]),
        .b(carry2[14:11]),
        .cin(cout),
        .sum(upper_sum[15:12]),
        .cout()
    );
    
    // Early termination detection
    wire early_term = (pp[2] == 0) && (pp[3] == 0);
    
    // Final product assembly
    always @(*) begin
        if (early_term) begin
            product = {8'b0, sum_low};
        end else begin
            product = {upper_sum, sum_low[7:0]};
        end
    end

endmodule

// 8-bit CSA module
module csa_8bit(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    output [7:0] sum,
    output [7:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = {(a[6:0] & b[6:0]) | (a[6:0] & c[6:0]) | (b[6:0] & c[6:0]), 1'b0};
endmodule

// 4-bit carry-lookahead adder
module cla_4bit(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [3:0] g = a & b;
    wire [3:0] p = a ^ b;
    
    wire [3:0] c;
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign cout = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | 
                 (p[3] & p[2] & p[1] & p[0] & c[0]);
    
    assign sum = p ^ c;
endmodule