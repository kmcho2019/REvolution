module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Booth encoder outputs
    wire [8:0] booth_sel [0:3];
    wire [15:0] pp [0:3];
    
    // Generate booth encoded partial products
    assign booth_sel[0] = {B[1:0], 1'b0};
    assign booth_sel[1] = B[3:1];
    assign booth_sel[2] = B[5:3];
    assign booth_sel[3] = B[7:5];
    
    // Generate partial products based on booth encoding
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : pp_gen
            always @(*) begin
                case (booth_sel[i])
                    3'b000, 3'b111: pp[i] = 16'b0;
                    3'b001, 3'b010: pp[i] = {{8{A[7]}}, A} << (2*i);
                    3'b011:        pp[i] = {A, 8'b0} << (2*i);
                    3'b100:        pp[i] = ~{A, 8'b0} << (2*i) + (1 << (2*i));
                    3'b101, 3'b110: pp[i] = ~{{8{A[7]}}, A} << (2*i) + (1 << (2*i));
                endcase
            end
        end
    endgenerate
    
    // Carry-save addition tree
    wire [15:0] sum1, carry1;
    wire [15:0] sum2, carry2;
    
    // First level CSA
    csa_adder csa1 (
        .a(pp[0]),
        .b(pp[1]),
        .c(pp[2]),
        .sum(sum1),
        .carry(carry1)
    );
    
    // Second level CSA
    csa_adder csa2 (
        .a(sum1),
        .b(carry1 << 1),
        .c(pp[3]),
        .sum(sum2),
        .carry(carry2)
    );
    
    // Final CPA
    assign product = sum2 + (carry2 << 1);

endmodule

module csa_adder (
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (b & c) | (a & c);
endmodule