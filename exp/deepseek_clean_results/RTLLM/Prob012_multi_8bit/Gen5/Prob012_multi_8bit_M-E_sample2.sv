module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Booth encoder outputs
    wire [8:0] booth_enc [0:3];
    wire [8:0] neg_A = {1'b1, ~A} + 1;  // 2's complement of A
    wire [8:0] neg_2A = {1'b1, ~(A << 1)} + 1;  // 2's complement of 2A
    
    // Generate booth encoding groups (including sign bit)
    wire [2:0] booth_sel [0:3];
    assign booth_sel[0] = {B[1], B[0], 1'b0};
    assign booth_sel[1] = B[3:1];
    assign booth_sel[2] = B[5:3];
    assign booth_sel[3] = B[7:5];
    
    // Booth multiplexers
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : booth_mux
            always @(*) begin
                case (booth_sel[i])
                    3'b000, 3'b111: booth_enc[i] = 9'b0;          // 0
                    3'b001, 3'b010: booth_enc[i] = {1'b0, A};      // +A
                    3'b011:        booth_enc[i] = {A, 1'b0};       // +2A
                    3'b100:        booth_enc[i] = {neg_A[8], neg_A}; // -2A
                    3'b101, 3'b110: booth_enc[i] = neg_A;          // -A
                endcase
            end
        end
    endgenerate
    
    // Sign extend and shift partial products
    wire [15:0] pp0 = {{7{booth_enc[0][8]}}, booth_enc[0]};
    wire [15:0] pp1 = {{5{booth_enc[1][8]}}, booth_enc[1], 2'b0};
    wire [15:0] pp2 = {{3{booth_enc[2][8]}}, booth_enc[2], 4'b0};
    wire [15:0] pp3 = {{1{booth_enc[3][8]}}, booth_enc[3], 6'b0};
    
    // Carry-save adder tree
    wire [15:0] sum1, carry1;
    wire [15:0] sum2, carry2;
    
    // First level: Add pp0 and pp1
    assign sum1 = pp0 ^ pp1;
    assign carry1 = (pp0 & pp1) << 1;
    
    // Second level: Add pp2 and sum1
    assign sum2 = pp2 ^ sum1;
    assign carry2 = (pp2 & sum1) << 1;
    
    // Final addition: sum2 + carry1 + carry2 + pp3
    assign product = sum2 + carry1 + carry2 + pp3;

endmodule