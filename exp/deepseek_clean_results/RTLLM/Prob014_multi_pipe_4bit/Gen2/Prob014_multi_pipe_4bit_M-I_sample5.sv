module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended versions of inputs
    wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b};

    // Partial products (registered immediately)
    reg [2*size-1:0] pp [size-1:0];
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1) begin
                pp[j] <= {(2*size){1'b0}};
            end
        end else begin
            for (j = 0; j < size; j = j + 1) begin
                pp[j] <= ext_b[j] ? (ext_a << j) : {(2*size){1'b0}};
            end
        end
    end

    // Pipeline stage 1: sum of pp[0] and pp[1]
    reg [2*size-1:0] stage1_sum;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum <= {(2*size){1'b0}};
        end else begin
            stage1_sum <= pp[0] + pp[1];
        end
    end

    // Pipeline stage 2: sum of stage1 and pp[2], plus pp[3]
    reg [2*size-1:0] stage2_sum;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= {(2*size){1'b0}};
            mul_out <= {(2*size){1'b0}};
        end else begin
            stage2_sum <= stage1_sum + pp[2];
            mul_out <= stage2_sum + pp[3];
        end
    end

endmodule