module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    localparam width = 2*size;

    // Extend multiplicand by adding 'size' zeros at MSB side (zero-extension)
    wire [width-1:0] a_ext = { {size{1'b0}}, mul_a };

    // Combinational partial products generation
    wire [width-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (a_ext << i) : {width{1'b0}};
        end
    endgenerate

    // Stage 1 registers: register partial products
    reg [width-1:0] pp_reg [size-1:0];
    integer idx;
    always @(posedge clk) begin
        if (!rst_n) begin
            for (idx = 0; idx < size; idx = idx + 1)
                pp_reg[idx] <= {width{1'b0}};
        end else begin
            for (idx = 0; idx < size; idx = idx + 1)
                pp_reg[idx] <= partial_products[idx];
        end
    end

    // Stage 2 registers: sum partial products in pairs and register results
    // For size=4: sum pp_reg[0]+pp_reg[1], pp_reg[2]+pp_reg[3]
    reg [width-1:0] lvl1_sum [1:0];
    always @(posedge clk) begin
        if (!rst_n) begin
            lvl1_sum[0] <= {width{1'b0}};
            lvl1_sum[1] <= {width{1'b0}};
        end else begin
            lvl1_sum[0] <= pp_reg[0] + pp_reg[1];
            lvl1_sum[1] <= pp_reg[2] + pp_reg[3];
        end
    end

    // Final stage: combinational addition of lvl1_sum and output registered product
    wire [width-1:0] final_sum;
    assign final_sum = lvl1_sum[0] + lvl1_sum[1];

    always @(posedge clk) begin
        if (!rst_n)
            mul_out <= {width{1'b0}};
        else
            mul_out <= final_sum;
    end

endmodule