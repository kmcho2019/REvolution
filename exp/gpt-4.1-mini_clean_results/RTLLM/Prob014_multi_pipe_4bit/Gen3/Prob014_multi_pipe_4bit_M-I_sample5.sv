module multi_pipe_4bit #(
    parameter size = 4
)(
    input                     clk,
    input                     rst_n,
    input      [size-1:0]     mul_a,
    input      [size-1:0]     mul_b,
    output reg [2*size-1:0]   mul_out
);

    // Extend multiplicand by 'size' zeros at MSB side
    wire [2*size-1:0] a_ext = { {size{1'b0}}, mul_a };

    // Partial products wires
    wire [2*size-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // Pipeline stage 1 registers to store partial products
    reg [2*size-1:0] partial_regs [0:size-1];

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j=0; j<size; j=j+1) begin
                partial_regs[j] <= {2*size{1'b0}};
            end
        end else begin
            for (j=0; j<size; j=j+1) begin
                partial_regs[j] <= partial_products[j];
            end
        end
    end

    // Pipeline stage 2 register to hold accumulated sum of partial products
    reg [2*size-1:0] sum_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg <= {2*size{1'b0}};
        end else begin
            // sum all partial products registered in stage 1
            reg [2*size-1:0] sum_tmp;
            sum_tmp = {2*size{1'b0}};
            for (j=0; j<size; j=j+1)
                sum_tmp = sum_tmp + partial_regs[j];
            sum_reg <= sum_tmp;
        end
    end

    // Output register stage: register the final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {2*size{1'b0}};
        else
            mul_out <= sum_reg;
    end

endmodule