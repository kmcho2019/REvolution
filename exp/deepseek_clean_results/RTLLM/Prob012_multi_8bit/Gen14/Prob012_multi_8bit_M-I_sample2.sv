module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Booth encoded partial products
    wire [8:0] A_ext = {A[7], A}; // Sign-extended A
    wire [8:0] A_neg = ~A_ext + 1; // -A
    
    // Booth encoder generates partial products
    wire [8:0] pp [4:0];
    wire [1:0] booth_sel [4:0];
    
    // Generate booth select signals
    assign booth_sel[0] = {B[1], B[0], 1'b0};
    assign booth_sel[1] = {B[3], B[2], B[1]};
    assign booth_sel[2] = {B[5], B[4], B[3]};
    assign booth_sel[3] = {B[7], B[6], B[5]};
    assign booth_sel[4] = {1'b0, 1'b0, B[7]};
    
    // Generate partial products based on Booth encoding
    genvar i;
    generate
        for (i = 0; i < 5; i = i + 1) begin : booth_pp
            always @(*) begin
                case (booth_sel[i])
                    3'b001, 3'b010: pp[i] = A_ext;
                    3'b011:         pp[i] = A_ext << 1;
                    3'b100:         pp[i] = A_neg << 1;
                    3'b101, 3'b110: pp[i] = A_neg;
                    default:        pp[i] = 9'b0;
                endcase
            end
        end
    endgenerate
    
    // Sign-extend partial products to 16 bits with proper shifting
    wire [15:0] pp0 = {{7{pp[0][8]}}, pp[0]};
    wire [15:0] pp1 = {{5{pp[1][8]}}, pp[1], 2'b0};
    wire [15:0] pp2 = {{3{pp[2][8]}}, pp[2], 4'b0};
    wire [15:0] pp3 = {{1{pp[3][8]}}, pp[3], 6'b0};
    wire [15:0] pp4 = {pp[4], 8'b0};
    
    // Carry-save adder tree (3:2 compressors)
    wire [15:0] sum1, carry1;
    assign {carry1, sum1} = pp0 + pp1 + pp2;
    
    wire [15:0] sum2, carry2;
    assign {carry2, sum2} = sum1 + carry1 + pp3;
    
    // Final addition (carry-propagate adder)
    assign product = sum2 + carry2 + pp4;

endmodule