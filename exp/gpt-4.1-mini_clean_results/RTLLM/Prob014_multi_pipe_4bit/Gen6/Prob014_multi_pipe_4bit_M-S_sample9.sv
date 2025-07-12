module multi_pipe_4bit #(parameter size = 4)(
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by adding 'size' zeros at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Level 1 registers: register extended inputs and multiplier
    reg [2*size-1:0] reg_mul_a;
    reg [size-1:0]   reg_mul_b;

    // On clock or reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_mul_a <= 0;
            reg_mul_b <= 0;
            mul_out <= 0;
        end else begin
            reg_mul_a <= ext_mul_a;
            reg_mul_b <= mul_b;
            // Compute partial products and sum them combinationally, then register the result as mul_out
            // Partial product: if bit i of multiplier is 1, shift reg_mul_a left by i, else 0
            // Sum over i = 0 to size-1
            integer i;
            reg [2*size-1:0] sum_partial;
            sum_partial = 0;
            for (i = 0; i < size; i = i + 1) begin
                if (reg_mul_b[i])
                    sum_partial = sum_partial + (reg_mul_a << i);
            end
            mul_out <= sum_partial;
        end
    end

endmodule