module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by zero-padding MSBs
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally
    wire [2*size-1:0] partial_product0 = mul_b[0] ? (ext_mul_a << 0) : {2*size{1'b0}};
    wire [2*size-1:0] partial_product1 = mul_b[1] ? (ext_mul_a << 1) : {2*size{1'b0}};
    wire [2*size-1:0] partial_product2 = mul_b[2] ? (ext_mul_a << 2) : {2*size{1'b0}};
    wire [2*size-1:0] partial_product3 = mul_b[3] ? (ext_mul_a << 3) : {2*size{1'b0}};

    // Pipeline Stage 1 registers: store each partial product separately
    reg [2*size-1:0] pp_reg0, pp_reg1, pp_reg2, pp_reg3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp_reg0 <= {2*size{1'b0}};
            pp_reg1 <= {2*size{1'b0}};
            pp_reg2 <= {2*size{1'b0}};
            pp_reg3 <= {2*size{1'b0}};
        end else begin
            pp_reg0 <= partial_product0;
            pp_reg1 <= partial_product1;
            pp_reg2 <= partial_product2;
            pp_reg3 <= partial_product3;
        end
    end

    // Pipeline Stage 2 register: sum all partial products
    reg [2*size-1:0] sum_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg <= {2*size{1'b0}};
        end else begin
            sum_reg <= pp_reg0 + pp_reg1 + pp_reg2 + pp_reg3;
        end
    end

    // Pipeline Stage 3 register: output registered sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= sum_reg;
        end
    end

endmodule