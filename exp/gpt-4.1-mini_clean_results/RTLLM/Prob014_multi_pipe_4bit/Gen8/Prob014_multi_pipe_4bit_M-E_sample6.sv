module multi_pipe_4bit #(parameter size = 4)(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire [size-1:0]      mul_a,
    input  wire [size-1:0]      mul_b,
    output reg  [(2*size)-1:0]  mul_out
);

    localparam product_width = 2 * size;

    // Zero-extended multiplicand (shifted and masked later)
    wire [product_width-1:0] a_ext = {{size{1'b0}}, mul_a};

    // Stage 1 registers: store partial products for each bit of mul_b
    reg [product_width-1:0] partial_reg [0:size-1];

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < size; i = i + 1)
                partial_reg[i] <= {product_width{1'b0}};
        end else begin
            for (i = 0; i < size; i = i + 1)
                partial_reg[i] <= mul_b[i] ? (a_ext << i) : {product_width{1'b0}};
        end
    end

    // Stage 2 registers: sum partial products in two halves and then sum final result
    reg [product_width-1:0] sum_lower; // sum of partial_reg[0]..partial_reg[size/2-1]
    reg [product_width-1:0] sum_upper; // sum of partial_reg[size/2]..partial_reg[size-1]

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_lower <= {product_width{1'b0}};
            sum_upper <= {product_width{1'b0}};
        end else begin
            // Sum lower half partial products
            sum_lower <= {product_width{1'b0}};
            for (i = 0; i < size/2; i = i + 1)
                sum_lower <= sum_lower + partial_reg[i];

            // Sum upper half partial products
            sum_upper <= {product_width{1'b0}};
            for (i = size/2; i < size; i = i + 1)
                sum_upper <= sum_upper + partial_reg[i];
        end
    end

    // Final product register: sum of two halves
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {product_width{1'b0}};
        else
            mul_out <= sum_lower + sum_upper;
    end

endmodule