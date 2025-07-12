module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    localparam width = 2*size;

    // Extend multiplicand by adding 'size' zeros at MSB side
    wire [width-1:0] a_ext = { {size{1'b0}}, mul_a };

    // 1) Generate partial products combinationally (width bits each)
    wire [width-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (a_ext << i) : {width{1'b0}};
        end
    endgenerate

    // 2) Pipeline stage 1: register partial products to balance pipeline
    reg [width-1:0] pp_reg [size-1:0];
    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx=0; idx<size; idx=idx+1)
                pp_reg[idx] <= {width{1'b0}};
        end else begin
            for (idx=0; idx<size; idx=idx+1)
                pp_reg[idx] <= partial_products[idx];
        end
    end

    // 3) Stage 2: Sum partial products in pairs (tree level 1)
    // Number of sums = size/2 (for size=4, 2 sums)
    // Support general even size; if odd, last partial product passes through
    localparam lvl1_cnt = (size+1)/2;
    reg [width-1:0] lvl1_sum [lvl1_cnt-1:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx=0; idx<lvl1_cnt; idx=idx+1)
                lvl1_sum[idx] <= {width{1'b0}};
        end else begin
            for (idx=0; idx<lvl1_cnt; idx=idx+1) begin
                if (2*idx +1 < size)
                    lvl1_sum[idx] <= pp_reg[2*idx] + pp_reg[2*idx + 1];
                else
                    lvl1_sum[idx] <= pp_reg[2*idx]; // Odd last element if size odd
            end
        end
    end

    // 4) Stage 3: Sum results of previous stage (tree level 2)
    // For size=4, lvl1_cnt=2, sum lvl1_sum[0]+lvl1_sum[1]
    reg [width-1:0] lvl2_sum;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lvl2_sum <= {width{1'b0}};
            mul_out <= {width{1'b0}};
        end else begin
            // Sum all lvl1 sums (for 4-bit size, this is just 2 inputs)
            // For larger sizes, more pipeline levels would be needed
            // Here we sum all lvl1_sum entries in one step (could be pipelined further if needed)
            reg [width-1:0] temp_sum;
            integer j;
            temp_sum = {width{1'b0}};
            for (j=0; j<lvl1_cnt; j=j+1)
                temp_sum = temp_sum + lvl1_sum[j];
            lvl2_sum <= temp_sum;

            // Output registered final product
            mul_out <= lvl2_sum;
        end
    end

endmodule