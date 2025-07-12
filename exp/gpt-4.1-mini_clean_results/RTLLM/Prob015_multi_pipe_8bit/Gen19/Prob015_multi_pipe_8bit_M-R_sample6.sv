module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline registers for enable signal (3-stage shift register)
    reg [2:0] mul_en_pipe;

    // Stage 1: Input registers for operands
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 2: Registers for partial products
    reg [15:0] pp_0_3;  // sum of partial_products[0..3]
    reg [15:0] pp_4_7;  // sum of partial_products[4..7]

    // Stage 3: Register for final product
    reg [15:0] mul_out_reg;

    // Partial products wires for current inputs
    wire [15:0] partial_products[7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Pipeline stage 1: sample inputs and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 3'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else begin
            mul_en_pipe <= {mul_en_pipe[1:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Pipeline stage 2: partial sum registers
    // Sum partial products [0..3] and [4..7] separately to reduce combinational delay
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp_0_3 <= 16'd0;
            pp_4_7 <= 16'd0;
        end else if (mul_en_pipe[0]) begin
            pp_0_3 <= partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];
            pp_4_7 <= partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7];
        end else begin
            pp_0_3 <= 16'd0;
            pp_4_7 <= 16'd0;
        end
    end

    // Pipeline stage 3: final sum and product register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            mul_out_reg <= pp_0_3 + pp_4_7;
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Output enable from MSB of enable pipeline
    assign mul_en_out = mul_en_pipe[2];

    // Output product gated by output enable
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule