module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    // Booth-encoded partial product generation
    wire [15:0] pp [3:0];
    wire [8:0] B_ext = {B, 1'b0};
    
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : booth_pp
            wire [1:0] sel = B_ext[2*i+1:2*i];
            wire [8:0] pp_val;
            
            always @(*) begin
                case (sel)
                    2'b01: pp_val = {1'b0, A};
                    2'b10: pp_val = ~{1'b0, A} + 1'b1;
                    2'b11: pp_val = {1'b0, {8{1'b0}}};
                    default: pp_val = {1'b0, {8{1'b0}}};
                endcase
            end
            
            assign pp[i] = $signed(pp_val) << (2*i);
        end
    endgenerate

    // Wallace tree reduction
    wire [15:0] sum1, carry1;
    wire [15:0] sum2, carry2;
    
    // First level: reduce 4 partial products to 2
    csa csa_level1_0 (pp[0], pp[1], pp[2], sum1, carry1);
    csa csa_level1_1 (sum1, {carry1[14:0], 1'b0}, pp[3], sum2, carry2);
    
    // Final addition using hybrid adder
    wire [15:0] final_sum;
    hybrid_adder final_adder (
        .a(sum2),
        .b({carry2[14:0], 1'b0}),
        .sum(final_sum)
    );
    
    always @(*) begin
        product = final_sum;
    end

endmodule

// Carry-Save Adder module
module csa (
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (a & c) | (b & c);
endmodule

// Hybrid adder (carry-select + carry-lookahead)
module hybrid_adder (
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    // First 8 bits using carry-lookahead
    wire [8:0] carry;
    assign carry[0] = 1'b0;
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : cla_part
            wire p = a[i] ^ b[i];
            wire g = a[i] & b[i];
            assign carry[i+1] = g | (p & carry[i]);
            assign sum[i] = p ^ carry[i];
        end
        
        // Upper 8 bits using carry-select
        wire [15:8] sum0, sum1;
        wire [7:0] b_upper = b[15:8];
        wire [7:0] a_upper = a[15:8];
        
        // Carry=0 case
        assign sum0 = a_upper + b_upper;
        // Carry=1 case
        assign sum1 = a_upper + b_upper + 1;
        
        // Mux selection
        assign sum[15:8] = carry[8] ? sum1 : sum0;
    endgenerate
endmodule