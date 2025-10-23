module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended multiplicand width
    localparam ext_size = 2 * size;

    // Stage 1 registers: extended multiplicand and multiplier
    reg [ext_size-1:0] reg_mul_a_ext;
    reg [size-1:0]     reg_mul_b;

    // Partial products (combinational)
    reg [ext_size-1:0] partials [0:size-1];

    integer i;

    // Stage 1: Register inputs with multiplicand extended by size zeros on MSB
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_mul_a_ext <= 0;
            reg_mul_b     <= 0;
        end else begin
            reg_mul_a_ext <= { {size{1'b0}}, mul_a };
            reg_mul_b     <= mul_b;
        end
    end

    // Generate partial products combinationally based on registered inputs
    always @(*) begin
        for (i = 0; i < size; i = i + 1) begin
            partials[i] = reg_mul_b[i] ? (reg_mul_a_ext << i) : {ext_size{1'b0}};
        end
    end

    // Stage 2: Sum partial products and register the result
    reg [2*size-1:0] sum_partials;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_partials <= 0;
            mul_out      <= 0;
        end else begin
            sum_partials = 0;
            for (i = 0; i < size; i = i + 1)
                sum_partials = sum_partials + partials[i];
            mul_out <= sum_partials;
        end
    end

endmodule