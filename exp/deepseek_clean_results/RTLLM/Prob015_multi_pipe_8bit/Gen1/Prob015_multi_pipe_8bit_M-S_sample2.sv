module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline registers
    reg enable_reg;
    reg [7:0] a_reg, b_reg;
    reg [15:0] product_reg;

    // Partial products with proper shifting
    wire [15:0] pp [7:0];
    
    // Generate properly shifted partial products
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = b_reg[i] ? (a_reg << i) : 16'b0;
        end
    endgenerate

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            enable_reg <= 1'b0;
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            product_reg <= 16'b0;
        end else begin
            enable_reg <= mul_en_in;
            
            if (mul_en_in) begin
                a_reg <= mul_a;
                b_reg <= mul_b;
            end
            
            // Single accumulation stage
            if (enable_reg) begin
                product_reg <= pp[0] + pp[1] + pp[2] + pp[3] + 
                               pp[4] + pp[5] + pp[6] + pp[7];
            end
        end
    end

    // Output assignments
    assign mul_en_out = enable_reg;
    assign mul_out = product_reg;

endmodule