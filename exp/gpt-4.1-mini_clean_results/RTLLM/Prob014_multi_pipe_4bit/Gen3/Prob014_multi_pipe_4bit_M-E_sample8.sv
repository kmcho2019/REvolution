module multi_pipe_4bit #(parameter size = 4)(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire [size-1:0]      mul_a,
    input  wire [size-1:0]      mul_b,
    output reg  [2*size-1:0]    mul_out
);

    // Extend inputs by size zeros at MSB
    wire [2*size-1:0] a_ext = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] b_ext = { {size{1'b0}}, mul_b };

    // Partial products for bits [1:0] of multiplier
    wire [2*size-1:0] pp0 = (mul_b[0]) ? (a_ext << 0) : {2*size{1'b0}};
    wire [2*size-1:0] pp1 = (mul_b[1]) ? (a_ext << 1) : {2*size{1'b0}};

    // Partial products for bits [3:2] of multiplier
    wire [2*size-1:0] pp2 = (mul_b[2]) ? (a_ext << 2) : {2*size{1'b0}};
    wire [2*size-1:0] pp3 = (mul_b[3]) ? (a_ext << 3) : {2*size{1'b0}};

    // Pipeline registers for intermediate sums
    reg [2*size-1:0] stage1_sum; // holds sum of pp0+pp1
    reg [2*size-1:0] stage2_sum; // holds sum of pp2+pp3
    reg [2*size-1:0] product_reg; // holds final product

    // Stage 1: Sum partial products pp0 and pp1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            stage1_sum <= {2*size{1'b0}};
        else
            stage1_sum <= pp0 + pp1;
    end

    // Stage 2: Sum partial products pp2 and pp3
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            stage2_sum <= {2*size{1'b0}};
        else
            stage2_sum <= pp2 + pp3;
    end

    // Stage 3: Add stage1_sum and stage2_sum to form final product output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            product_reg <= {2*size{1'b0}};
        else
            product_reg <= stage1_sum + stage2_sum;
    end

    // Output registered final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {2*size{1'b0}};
        else
            mul_out <= product_reg;
    end

endmodule