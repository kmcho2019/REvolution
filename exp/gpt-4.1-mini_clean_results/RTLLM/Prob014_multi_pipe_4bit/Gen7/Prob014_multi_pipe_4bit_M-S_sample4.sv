module multi_pipe_4bit #(parameter size = 4)(
    input                    clk,
    input                    rst_n,
    input      [size-1:0]    mul_a,
    input      [size-1:0]    mul_b,
    output reg [2*size-1:0]  mul_out
);

    // Extend multiplicand by adding 'size' zeros at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Pipeline stage 1 registers: registered multiplicand and multiplier
    reg [2*size-1:0] reg_mul_a;
    reg [size-1:0]   reg_mul_b;

    // Pipeline stage 2 register: holds the sum of partial products
    reg [2*size-1:0] reg_sum;

    // Partial products array (wires)
    wire [2*size-1:0] partial_products [size-1:0];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = reg_mul_b[i] ? (reg_mul_a << i) : 0;
        end
    endgenerate

    // Combinational sum of partial products
    wire [2*size-1:0] partial_sum = 
        partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];

    // Sequential logic: pipeline registers and output update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_mul_a <= 0;
            reg_mul_b <= 0;
            reg_sum   <= 0;
            mul_out   <= 0;
        end else begin
            // Stage 1: register inputs
            reg_mul_a <= ext_mul_a;
            reg_mul_b <= mul_b;

            // Stage 2: register sum of partial products
            reg_sum <= partial_sum;

            // Output assignment from stage 2 register
            mul_out <= reg_sum;
        end
    end

endmodule