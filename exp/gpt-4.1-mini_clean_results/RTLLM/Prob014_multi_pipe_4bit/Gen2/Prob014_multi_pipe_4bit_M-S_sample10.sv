module multi_pipe_4bit #(parameter size = 4)(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire [size-1:0]      mul_a,
    input  wire [size-1:0]      mul_b,
    output reg  [2*size-1:0]    mul_out
);

    // Extend multiplicand by size zeros at MSB
    wire [2*size-1:0] a_ext = { {size{1'b0}}, mul_a };

    // Partial products: if mul_b[i] is 1, shift multiplicand left by i, else zero
    wire [2*size-1:0] partial [0:size-1];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial
            assign partial[i] = mul_b[i] ? (a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // Pipeline registers: stage1 sums partial products in pairs
    reg [2*size-1:0] reg_stage1 [0:1];
    // Stage2 sums the two stage1 results
    reg [2*size-1:0] reg_stage2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_stage1[0] <= {2*size{1'b0}};
            reg_stage1[1] <= {2*size{1'b0}};
        end else begin
            reg_stage1[0] <= partial[0] + partial[1];
            reg_stage1[1] <= partial[2] + partial[3];
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_stage2 <= {2*size{1'b0}};
        end else begin
            reg_stage2 <= reg_stage1[0] + reg_stage1[1];
        end
    end

    // Output register for final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {2*size{1'b0}};
        else
            mul_out <= reg_stage2;
    end

endmodule