module multi_pipe_8bit (
    input         clk,
    input         rst_n,
    input         mul_en_in,
    input  [7:0]  mul_a,
    input  [7:0]  mul_b,
    output        mul_en_out,
    output [15:0] mul_out
);

    // Pipeline registers for enable signals (length: 4 cycles pipeline)
    reg [3:0] mul_en_out_reg;

    // Input registers for operands
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires (8 partial products, each 16 bits)
    wire [15:0] temp [7:0];

    // Partial sums registers for pipeline stages
    reg [15:0] sum0;
    reg [15:0] sum1;
    reg [15:0] sum2;

    // Final product register
    reg [15:0] mul_out_reg;

    // Input enable and operand registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out_reg <= 4'b0;
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else begin
            mul_en_out_reg <= {mul_en_out_reg[2:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Output enable: last stage of enable pipeline
    assign mul_en_out = mul_en_out_reg[3];

    // Generate partial products (shifted accordingly)
    // Each partial product is mul_a & mul_b bit replicated and shifted
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_partial_products
            assign temp[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Pipeline sum stage 1 (sum four partial products in two pairs)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum0 <= 16'b0;
        end else begin
            // sum0 adds partial products for bits 0..3
            sum0 <= temp[0] + temp[1] + temp[2] + temp[3];
        end
    end

    // Pipeline sum stage 2 (sum four partial products in two pairs)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum1 <= 16'b0;
        end else begin
            // sum1 adds partial products for bits 4..7
            sum1 <= temp[4] + temp[5] + temp[6] + temp[7];
        end
    end

    // Pipeline sum stage 3 (sum the two sums from previous stages)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum2 <= 16'b0;
        end else begin
            sum2 <= sum0 + sum1;
        end
    end

    // Final product register stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'b0;
        end else begin
            mul_out_reg <= sum2;
        end
    end

    // Output mux: valid product when enable is asserted
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule