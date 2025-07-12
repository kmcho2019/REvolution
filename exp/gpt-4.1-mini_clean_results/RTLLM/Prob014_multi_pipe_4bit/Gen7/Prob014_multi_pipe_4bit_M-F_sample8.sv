module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend inputs by padding 'size' zeros to MSBs
    wire [2*size-1:0] a_ext = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] b_ext = { {size{1'b0}}, mul_b };

    // Stage 1 registers: store partial products for each bit of mul_b
    reg [2*size-1:0] partial_products_reg [0:size-1];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < size; i = i + 1) begin
                partial_products_reg[i] <= {2*size{1'b0}};
            end
        end else begin
            for (i = 0; i < size; i = i + 1) begin
                // Calculate partial product for bit i of mul_b
                partial_products_reg[i] <= b_ext[i] ? (a_ext << i) : {2*size{1'b0}};
            end
        end
    end

    // Stage 2 register: sum all partial products
    reg [2*size-1:0] stage2_sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= {2*size{1'b0}};
            mul_out    <= {2*size{1'b0}};
        end else begin
            // Sum all partial products stored in stage 1 registers
            stage2_sum <= {2*size{1'b0}};
            for (i = 0; i < size; i = i + 1) begin
                stage2_sum <= stage2_sum + partial_products_reg[i];
            end
            mul_out <= stage2_sum;
        end
    end

endmodule