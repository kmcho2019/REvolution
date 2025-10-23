module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [63:0] product_reg;
    reg signed [31:0] c_next;
    
    // Input change detection
    wire inputs_changed = (a != a_reg) || (b != b_reg);
    
    // Booth-encoded partial products (simplified representation)
    wire signed [63:0] partial_products [15:0];
    generate
        for (genvar i = 0; i < 16; i = i+1) begin
            assign partial_products[i] = (b_reg[2*i+1:2*i-1] == 3'b000 || b_reg[2*i+1:2*i-1] == 3'b111) ? 64'b0 :
                                      (b_reg[2*i+1:2*i-1] == 3'b001 || b_reg[2*i+1:2*i-1] == 3'b010) ? (a_reg << (2*i)) :
                                      (b_reg[2*i+1:2*i-1] == 3'b011) ? (a_reg << (2*i+1)) :
                                      (b_reg[2*i+1:2*i-1] == 3'b100) ? -(a_reg << (2*i+1)) :
                                      -(a_reg << (2*i));
        end
    endgenerate

    always @(posedge clk) begin
        if (rst) begin
            // Reset all pipeline stages
            a_reg <= 32'b0;
            b_reg <= 32'b0;
            product_reg <= 64'b0;
            c <= 32'b0;
        end else begin
            // Pipeline stage 1: Register inputs and compute partial products
            if (inputs_changed) begin
                a_reg <= a;
                b_reg <= b;
            end
            
            // Pipeline stage 2: Sum partial products and accumulate
            if (inputs_changed) begin
                product_reg <= partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3] +
                              partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7] +
                              partial_products[8] + partial_products[9] + partial_products[10] + partial_products[11] +
                              partial_products[12] + partial_products[13] + partial_products[14] + partial_products[15];
            end
            
            // Optional saturation logic (uncomment if needed)
            // if (product_reg[63:32] != {32{product_reg[31]}})
            //     c <= product_reg[63] ? 32'h80000000 : 32'h7FFFFFFF;
            // else
            c <= c + product_reg[31:0];
        end
    end

endmodule