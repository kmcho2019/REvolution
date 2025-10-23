module multi_pipe_4bit #(parameter size = 4)(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire [size-1:0]      mul_a,
    input  wire [size-1:0]      mul_b,
    output reg  [2*size-1:0]    mul_out
);

    // Extend multiplicand with size zeros at MSB
    wire [2*size-1:0] a_ext = { {size{1'b0}}, mul_a };

    // Generate partial products for each bit of mul_b
    wire [2*size-1:0] partial [size-1:0];
    genvar i;
    generate
        for(i = 0; i < size; i = i + 1) begin : gen_partial
            assign partial[i] = mul_b[i] ? (a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // First pipeline register stage to sum all partial products
    reg [2*size-1:0] stage1_reg;

    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            stage1_reg <= {2*size{1'b0}};
        else begin
            // Sum all partial products combinationally then register
            stage1_reg <= {2*size{1'b0}};
            for (idx = 0; idx < size; idx = idx + 1)
                stage1_reg <= stage1_reg + partial[idx];
        end
    end

    // Second pipeline register stage to hold final product output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {2*size{1'b0}};
        else
            mul_out <= stage1_reg;
    end

endmodule