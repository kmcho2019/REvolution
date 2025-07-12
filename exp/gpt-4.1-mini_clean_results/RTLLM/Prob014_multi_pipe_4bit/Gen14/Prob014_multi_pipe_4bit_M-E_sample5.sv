module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    localparam OUT_W = 2*size;

    // Extend multiplicand by size zeros at MSB side to make width 2*size
    wire [OUT_W-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Partial products combinational array: partial_products[i] = ext_mul_a shifted left by i if mul_b[i] = 1, else 0
    wire [OUT_W-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {OUT_W{1'b0}};
        end
    endgenerate

    // Stage 1 registers: store each partial product
    reg [OUT_W-1:0] stage1_pp [0:size-1];

    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx=0; idx<size; idx=idx+1)
                stage1_pp[idx] <= {OUT_W{1'b0}};
        end else begin
            for (idx=0; idx<size; idx=idx+1)
                stage1_pp[idx] <= partial_products[idx];
        end
    end

    // Stage 2: sum partial products in two groups (split into half)
    localparam half = (size+1)/2; // upper half includes center if odd

    // Sum lower half group combinationally
    wire [OUT_W-1:0] sum_lower;
    assign sum_lower = 
        (half > 0) ? (stage1_pp[0] 
        + ((half > 1) ? stage1_pp[1] : {OUT_W{1'b0}})
        + ((half > 2) ? stage1_pp[2] : {OUT_W{1'b0}})) : {OUT_W{1'b0}};
    // Since size=4 fixed, this sums stage1_pp[0], [1], [2] for lower half

    // Sum upper half group combinationally
    wire [OUT_W-1:0] sum_upper;
    assign sum_upper = 
        (size > half) ? (stage1_pp[half] 
        + ((size > half+1) ? stage1_pp[half+1] : {OUT_W{1'b0}})
        + ((size > half+2) ? stage1_pp[half+2] : {OUT_W{1'b0}})) : {OUT_W{1'b0}};
    // For size=4 and half=2, sums stage1_pp[2], [3], [4](not valid) but we limit indexing

    // Stage 2 registers: register sum_lower and sum_upper
    reg [OUT_W-1:0] reg_sum_lower, reg_sum_upper;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_sum_lower <= {OUT_W{1'b0}};
            reg_sum_upper <= {OUT_W{1'b0}};
        end else begin
            reg_sum_lower <= sum_lower;
            reg_sum_upper <= sum_upper;
        end
    end

    // Final stage: sum the two registered sums to produce mul_out, registered on clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {OUT_W{1'b0}};
        end else begin
            mul_out <= reg_sum_lower + reg_sum_upper;
        end
    end

endmodule