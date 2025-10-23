module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended multiplicand (only mul_a needs extension)
    wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};

    // Pipeline stage 1: calculate pp0 + pp1
    reg [2*size-1:0] stage1_sum;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum <= 0;
        end else begin
            stage1_sum <= (mul_b[0] ? ext_a : 0) + 
                          (mul_b[1] ? (ext_a << 1) : 0);
        end
    end

    // Pipeline stage 2: calculate pp2 + pp3 and final sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= stage1_sum + 
                      (mul_b[2] ? (ext_a << 2) : 0) + 
                      (mul_b[3] ? (ext_a << 3) : 0);
        end
    end

endmodule