module multi_8bit (
    input wire [7:0] A,
    input wire [7:0] B,
    output wire [15:0] product
);

    // Booth encoder outputs
    wire [2:0] booth_bits [0:3];
    wire [8:0] partial_products [0:3];
    
    // Modified Booth encoding (radix-4)
    // Append 0 to B for encoding
    wire [8:0] B_ext = {B, 1'b0};
    
    // Generate Booth encoded bits
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : booth_encoding
            localparam [2:0] sel = B_ext[i*2+2:i*2];
            always @(*) begin
                case (sel)
                    3'b000, 3'b111: booth_bits[i] = 3'b000;  // 0
                    3'b001, 3'b010: booth_bits[i] = 3'b001;  // +1
                    3'b011:         booth_bits[i] = 3'b010;  // +2
                    3'b100:         booth_bits[i] = 3'b110;  // -2
                    3'b101, 3'b110: booth_bits[i] = 3'b101;  // -1
                endcase
            end
            
            // Generate partial products
            wire [8:0] pp;
            assign pp = ({9{booth_bits[i][2]}} ^ {1'b0, A}) + booth_bits[i][2];
            assign partial_products[i] = (booth_bits[i][1:0] == 2'b00) ? 9'b0 :
                                       (booth_bits[i][1:0] == 2'b01) ? {1'b0, A} :
                                       (booth_bits[i][1:0] == 2'b10) ? {A, 1'b0} :
                                       {~A, 1'b1};
        end
    endgenerate

    // Sign extension for partial products
    wire [15:0] pp_ext [0:3];
    assign pp_ext[0] = {{7{partial_products[0][8]}}, partial_products[0]};
    assign pp_ext[1] = {{5{partial_products[1][8]}}, partial_products[1], 2'b0};
    assign pp_ext[2] = {{3{partial_products[2][8]}}, partial_products[2], 4'b0};
    assign pp_ext[3] = {{1{partial_products[3][8]}}, partial_products[3], 6'b0};

    // Wallace tree reduction (4:2 compressor)
    wire [15:0] sum1, carry1;
    assign {carry1, sum1} = pp_ext[0] + pp_ext[1] + pp_ext[2];
    
    // Final addition
    assign product = sum1 + carry1 + pp_ext[3];

endmodule