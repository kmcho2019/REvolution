module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by 'size' zeros at MSB side
    wire [2*size-1:0] a_ext = { {size{1'b0}}, mul_a };

    // Stage 1 registers: one partial product per multiplier bit, each partial product = multiplicand & mul_b[i] shifted by i
    reg [2*size-1:0] partial_regs [0:size-1];

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < size; i = i + 1) begin
                partial_regs[i] <= {2*size{1'b0}};
            end
        end else begin
            for (i = 0; i < size; i = i + 1) begin
                if (mul_b[i])
                    partial_regs[i] <= (a_ext << i);
                else
                    partial_regs[i] <= {2*size{1'b0}};
            end
        end
    end

    // Stage 2 register: accumulator summing the partial products progressively
    reg [2*size-1:0] acc_reg;

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc_reg <= {2*size{1'b0}};
        end else begin
            // Sum partial products sequentially each clock cycle to implement pipeline accumulation
            reg [2*size-1:0] sum_tmp;
            sum_tmp = {2*size{1'b0}};
            for (j = 0; j < size; j = j + 1)
                sum_tmp = sum_tmp + partial_regs[j];
            acc_reg <= sum_tmp;
        end
    end

    // Output register stage: register the final product from accumulator register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {2*size{1'b0}};
        else
            mul_out <= acc_reg;
    end

endmodule