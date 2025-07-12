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

    // Partial products array (wires)
    wire [2*size-1:0] partial_products [size-1:0];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = reg_mul_b[i] ? (reg_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 2 pipeline registers: two sums of partial products to reduce addition complexity
    reg [2*size-1:0] sum_lower;  // sum of partial_products[0] and partial_products[1]
    reg [2*size-1:0] sum_upper;  // sum of partial_products[2] and partial_products[3]

    // Stage 3 pipeline register: final product sum
    reg [2*size-1:0] reg_sum;

    // Add partial products pairwise combinationally
    wire [2*size-1:0] sum_lower_wire = partial_products[0] + partial_products[1];
    wire [2*size-1:0] sum_upper_wire = partial_products[2] + partial_products[3];

    // Stage 3 addition combinational wires
    wire [2*size-1:0] final_sum_wire = sum_lower + sum_upper;

    // Sequential logic: pipeline registers and output update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_mul_a <= {2*size{1'b0}};
            reg_mul_b <= {size{1'b0}};
            sum_lower <= {2*size{1'b0}};
            sum_upper <= {2*size{1'b0}};
            reg_sum   <= {2*size{1'b0}};
            mul_out   <= {2*size{1'b0}};
        end else begin
            // Stage 1: register inputs
            reg_mul_a <= ext_mul_a;
            reg_mul_b <= mul_b;

            // Stage 2: register sum of partial products pairwise
            sum_lower <= sum_lower_wire;
            sum_upper <= sum_upper_wire;

            // Stage 3: register final sum of sums
            reg_sum <= final_sum_wire;

            // Output assignment from final sum register
            mul_out <= reg_sum;
        end
    end

endmodule