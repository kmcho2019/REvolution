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
    // For size=4, 2 sums; if odd size, last partial product passes through
    localparam lvl1_cnt = (size + 1) / 2;
    reg [width-1:0] lvl1_sum [lvl1_cnt-1:0];
    always @(posedge clk) begin
        if (!rst_n) begin
            for (idx = 0; idx < lvl1_cnt; idx = idx + 1)
                lvl1_sum[idx] <= {width{1'b0}};
        end else begin
            for (idx = 0; idx < lvl1_cnt; idx = idx + 1) begin
                if ((2*idx + 1) < size)
                    lvl1_sum[idx] <= pp_reg[2*idx] + pp_reg[2*idx + 1];
                else
                    lvl1_sum[idx] <= pp_reg[2*idx];  // pass through if odd number
            end
        end
    end

    // Final stage: combinational addition of lvl1_sum and output registered product
    wire [width-1:0] final_sum;
    generate
        if (lvl1_cnt == 2) begin
            // size=4 case: sum two entries
            assign final_sum = lvl1_sum[0] + lvl1_sum[1];
        end else if (lvl1_cnt == 1) begin
            // size=1 or 2: only one sum to pass
            assign final_sum = lvl1_sum[0];
        end else begin
            // General case for odd sizes > 4 (not fully pipelined)
            // Sum all lvl1_sum entries combinationally
            wire [width-1:0] sum_all [lvl1_cnt-1:0];
            integer j;
            // Use a generate-for loop for summation (folding)
            reg [width-1:0] tmp_sum;
            always @(*) begin
                tmp_sum = {width{1'b0}};
                for (j = 0; j < lvl1_cnt; j = j + 1)
                    tmp_sum = tmp_sum + lvl1_sum[j];
            end
            assign final_sum = tmp_sum;
        end
    endgenerate

    always @(posedge clk) begin
        if (!rst_n)
            mul_out <= {width{1'b0}};
        else
            mul_out <= final_sum;
    end

endmodule