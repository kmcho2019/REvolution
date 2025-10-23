module multi_pipe_4bit #(parameter size = 4) (
    input                 clk,
    input                 rst_n,
    input      [size-1:0] mul_a,
    input      [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    localparam ext_size = size * 2; // 8 for size=4

    // Stage 1 registers: extended inputs
    reg [ext_size-1:0] reg_mul_a;
    reg [size-1:0]     reg_mul_b;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_mul_a <= {ext_size{1'b0}};
            reg_mul_b <= {size{1'b0}};
        end else begin
            reg_mul_a <= {{size{1'b0}}, mul_a};  // size zeros + mul_a
            reg_mul_b <= mul_b;
        end
    end

    // Generate and sum partial products combinationally
    integer i;
    reg [ext_size-1:0] sum_partial;
    always @(*) begin
        sum_partial = {ext_size{1'b0}};
        for (i = 0; i < size; i = i + 1) begin
            if (reg_mul_b[i])
                sum_partial = sum_partial + (reg_mul_a << i);
        end
    end

    // Stage 2 register: final output product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {(2*size){1'b0}};
        else
            mul_out <= sum_partial;
    end

endmodule