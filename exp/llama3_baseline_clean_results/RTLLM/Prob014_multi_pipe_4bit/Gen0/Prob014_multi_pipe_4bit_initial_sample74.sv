module multi_pipe_4bit #(
    parameter size = 4
) (
    input   clk,
    input   rst_n,
    input   [size-1:0] mul_a,
    input   [size-1:0] mul_b,
    output  [2*size-1:0] mul_out
);

    // extension of input signals by adding "size" number of zero bits at the most significant bit positions
    wire [2*size-1:0] mul_a_ext = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] mul_b_ext = { {size{1'b0}}, mul_b };

    // first level register
    reg [2*size-1:0] partial_sum;
    reg [2*size-1:0] partial_sum_next;

    // generate block to perform multiplication for each bit position of the multiplier (mul_b)
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            partial_sum <= {2*size{1'b0}};
        end else begin
            partial_sum <= partial_sum_next;
        end
    end

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin
            // calculate partial product
            wire [2*size-1:0] partial_product;
            assign partial_product = (mul_b_ext[i] == 1'b1) ? (mul_a_ext << i) : {2*size{1'b0}};

            // add partial products
            if (i == 0) begin
                assign partial_sum_next = partial_product;
            end else begin
                assign partial_sum_next = partial_sum + partial_product;
            end
        end
    endgenerate

    // second level register
    reg [2*size-1:0] final_sum;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            final_sum <= {2*size{1'b0}};
        end else begin
            final_sum <= partial_sum;
        end
    end

    assign mul_out = final_sum;

endmodule