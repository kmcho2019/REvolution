module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Booth encoder outputs
    wire [1:0] booth_sel [3:0];
    wire [3:0] booth_neg;
    
    // Generate Booth encoding for each 3-bit window (with overlap)
    booth_encoder be0 (.b({B[1:0], 1'b0}), .sel(booth_sel[0]), .neg(booth_neg[0]));
    booth_encoder be1 (.b(B[3:1]), .sel(booth_sel[1]), .neg(booth_neg[1]));
    booth_encoder be2 (.b(B[5:3]), .sel(booth_sel[2]), .neg(booth_neg[2]));
    booth_encoder be3 (.b({B[7], B[7:6]}), .sel(booth_sel[3]), .neg(booth_neg[3]));

    // Generate partial products
    wire [15:0] pp [3:0];
    
    generate
        genvar i;
        for (i = 0; i < 4; i = i + 1) begin : pp_gen
            assign pp[i] = booth_neg[i] ? 
                         ~{ {8{A[7]}}, (A << (2*i)) } + 1'b1 :  // Negative case
                         { {8{A[7]}}, (A << (2*i)) };            // Positive case
            
            // Apply Booth selection (0, 1, or 2)
            assign pp[i] = (booth_sel[i] == 2'b00) ? 16'b0 :
                          (booth_sel[i] == 2'b01) ? pp[i] :
                          (booth_sel[i] == 2'b10) ? {pp[i][14:0], 1'b0} :
                          16'b0;
        end
    endgenerate

    // Wallace tree compression
    wire [15:0] s1, c1;
    wallace_4to2 wt1 (
        .pp0(pp[0]),
        .pp1(pp[1]),
        .pp2(pp[2]),
        .pp3(pp[3]),
        .sum(s1),
        .carry(c1)
    );

    // Final adder
    assign product = s1 + {c1[14:0], 1'b0};

endmodule

// Booth encoder module
module booth_encoder (
    input [2:0] b,
    output [1:0] sel,
    output neg
);
    assign sel = (b == 3'b000 || b == 3'b111) ? 2'b00 :
                (b == 3'b001 || b == 3'b010) ? 2'b01 :
                (b == 3'b011) ? 2'b10 :
                (b == 3'b100) ? 2'b10 : 2'b01;
    
    assign neg = (b[2] & (b[1] | b[0])) || 
                (b[2] & ~b[1] & ~b[0]) ||
                (~b[2] & b[1] & b[0]);
endmodule

// Wallace tree compressor (4:2)
module wallace_4to2 (
    input [15:0] pp0,
    input [15:0] pp1,
    input [15:0] pp2,
    input [15:0] pp3,
    output [15:0] sum,
    output [15:0] carry
);
    // First level compression
    wire [15:0] s0, c0;
    wire [15:0] s1, c1;
    
    // Compress pp0 and pp1
    assign s0 = pp0 ^ pp1;
    assign c0 = pp0 & pp1;
    
    // Compress pp2 and pp3
    assign s1 = pp2 ^ pp3;
    assign c1 = pp2 & pp3;
    
    // Second level compression
    assign sum = s0 ^ s1;
    assign carry = (s0 & s1) | (c0 | c1);
endmodule