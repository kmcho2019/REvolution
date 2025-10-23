module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    // Booth encoding
    wire [2:0] booth_bits [0:3];
    assign booth_bits[0] = {B[1], B[0], 1'b0};
    assign booth_bits[1] = {B[3], B[2], B[1]};
    assign booth_bits[2] = {B[5], B[4], B[3]};
    assign booth_bits[3] = {B[7], B[6], B[5]};

    // Generate partial products
    wire [8:0] pp [0:3];
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : booth_pp
            always @(*) begin
                case (booth_bits[i])
                    3'b000, 3'b111: pp[i] = 9'b0;
                    3'b001, 3'b010: pp[i] = {A[7], A};
                    3'b011:         pp[i] = {A, 1'b0};
                    3'b100:         pp[i] = ~{A, 1'b0} + 1'b1;
                    3'b101, 3'b110: pp[i] = ~{A[7], A} + 1'b1;
                endcase
            end
        end
    endgenerate

    // Shifted partial products
    wire [15:0] shifted_pp [0:3];
    assign shifted_pp[0] = {{7{pp[0][8]}}, pp[0]};
    assign shifted_pp[1] = {{5{pp[1][8]}}, pp[1], 2'b0};
    assign shifted_pp[2] = {{3{pp[2][8]}}, pp[2], 4'b0};
    assign shifted_pp[3] = {{1{pp[3][8]}}, pp[3], 6'b0};

    // Accumulate partial products
    always @(*) begin
        product = shifted_pp[0] + shifted_pp[1] + shifted_pp[2] + shifted_pp[3];
    end

endmodule