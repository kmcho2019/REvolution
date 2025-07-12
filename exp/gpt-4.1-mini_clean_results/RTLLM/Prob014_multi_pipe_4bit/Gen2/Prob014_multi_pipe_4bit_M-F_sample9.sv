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

    // 1) Extend multiplicand by adding 'size' zeros at MSB side
    wire [width-1:0] a_ext = { {size{1'b0}}, mul_a };

    // 2) Generate partial products combinationally (width bits each)
    wire [width-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (a_ext << i) : {width{1'b0}};
        end
    endgenerate

    // 3) Stage 1: Register partial products
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

    // 4) Stage 2: Sum partial products in pairs and register sums
    localparam lvl1_cnt = (size + 1) / 2;
    reg [width-1:0] lvl1_sum [lvl1_cnt-1:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx=0; idx<lvl1_cnt; idx=idx+1)
                lvl1_sum[idx] <= {width{1'b0}};
        end else begin
            for (idx=0; idx<lvl1_cnt; idx=idx+1) begin
                if (2*idx + 1 < size)
                    lvl1_sum[idx] <= pp_reg[2*idx] + pp_reg[2*idx + 1];
                else
                    lvl1_sum[idx] <= pp_reg[2*idx]; // For odd size last element
            end
        end
    end

    // 5) Stage 3: Sum results from lvl1_sum into lvl2_sum and register
    reg [width-1:0] lvl2_sum;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lvl2_sum <= {width{1'b0}};
        end else begin
            reg [width-1:0] temp_sum;
            integer j;
            temp_sum = {width{1'b0}};
            for (j=0; j<lvl1_cnt; j=j+1)
                temp_sum = temp_sum + lvl1_sum[j];
            lvl2_sum <= temp_sum;
        end
    end

    // 6) Stage 4: Register final output mul_out
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {width{1'b0}};
        end else begin
            mul_out <= lvl2_sum;
        end
    end

endmodule