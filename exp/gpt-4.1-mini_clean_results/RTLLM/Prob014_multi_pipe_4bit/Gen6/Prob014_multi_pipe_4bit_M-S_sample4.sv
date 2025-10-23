module multi_pipe_4bit #(parameter size = 4)(
    input  wire                clk,
    input  wire                rst_n,
    input  wire [size-1:0]     mul_a,
    input  wire [size-1:0]     mul_b,
    output reg  [2*size-1:0]   mul_out
);

    // Extend multiplicand with zeros at MSB
    wire [2*size-1:0] a_ext = { {size{1'b0}}, mul_a };

    // Partial products: generate shifted versions or zero based on mul_b bits
    wire [2*size-1:0] partial [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial
            assign partial[i] = mul_b[i] ? (a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // First pipeline stage register: sum all partial products except the last
    reg [2*size-1:0] stage1_reg;
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            stage1_reg <= 0;
        else begin
            stage1_reg <= {2*size{1'b0}};
            for (j = 0; j < size-1; j = j + 1)
                stage1_reg <= stage1_reg + partial[j];
        end
    end

    // Second pipeline stage register: add stage1_reg with the last partial product for final output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= 0;
        else
            mul_out <= stage1_reg + partial[size-1];
    end

endmodule