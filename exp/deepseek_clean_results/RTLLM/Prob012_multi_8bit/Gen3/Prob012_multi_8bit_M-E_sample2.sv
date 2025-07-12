module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    // Booth encoder outputs
    wire [2:0] booth_sel [3:0];
    wire [8:0] booth_pp [3:0];
    
    // Generate booth encoding and partial products
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : booth_gen
            // Radix-4 Booth encoding
            wire [2:0] b_group;
            if (i == 0) begin
                assign b_group = {B[1], B[0], 1'b0};
            end else begin
                assign b_group = {B[2*i+1], B[2*i], B[2*i-1]};
            end
            
            // Booth decoder
            assign booth_sel[i] = b_group;
            
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
        end
    endgenerate
    
    // Sign extension for partial products
    wire [15:0] pp0 = {{7{booth_pp[0][8]}}, booth_pp[0]};
    wire [15:0] pp1 = {{5{booth_pp[1][8]}}, booth_pp[1], 2'b0};
    wire [15:0] pp2 = {{3{booth_pp[2][8]}}, booth_pp[2], 4'b0};
    wire [15:0] pp3 = {{1{booth_pp[3][8]}}, booth_pp[3], 6'b0};
    
    // Wallace tree reduction
    wire [15:0] sum1, carry1;
    full_adder_16bit fa1 (
        .a(pp0),
        .b(pp1),
        .cin(16'b0),
        .sum(sum1),
        .cout(carry1)
    );
    
    wire [15:0] sum2, carry2;
    full_adder_16bit fa2 (
        .a(pp2),
        .b(pp3),
        .cin(16'b0),
        .sum(sum2),
        .cout(carry2)
    );
    
    wire [15:0] sum3, carry3;
    full_adder_16bit fa3 (
        .a(sum1),
        .b(sum2),
        .cin({15'b0, 1'b0}),
        .sum(sum3),
        .cout(carry3)
    );
    
    // Final addition
    always @(*) begin
        product = sum3 + {carry1[14:0], 1'b0} + {carry2[14:0], 1'b0} + {carry3[14:0], 1'b0};
    end

endmodule

// 16-bit full adder module
module full_adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input [15:0] cin,
    output [15:0] sum,
    output [15:0] cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule