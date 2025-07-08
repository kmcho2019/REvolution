module multi_pipe_8bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        mul_en_in,
    input  wire [7:0]  mul_a,
    input  wire [7:0]  mul_b,
    output wire        mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline stage registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Enable pipeline register (8 bits shift register for tracking enable over stages)
    reg [7:0] mul_en_out_reg;

    // Partial products (8 partial products, each 16-bit wide)
    wire [15:0] partial_products [7:0];

    // Registers for summation stages (7 pipeline stages to sum partial products)
    reg [15:0] sum_stage1;
    reg [15:0] sum_stage2;
    reg [15:0] sum_stage3;
    reg [15:0] sum_stage4;
    reg [15:0] sum_stage5;
    reg [15:0] sum_stage6;
    reg [15:0] sum_stage7;

    // Final output register
    reg [15:0] mul_out_reg;

    integer i;
    // Generate partial products by ANDing mul_a with each bit of mul_b shifted accordingly
    // This is combinational logic
    generate
        genvar idx;
        for (idx = 0; idx < 8; idx = idx + 1) begin : gen_partial_products
            assign partial_products[idx] = mul_b_reg[idx] ? (mul_a_reg << idx) : 16'd0;
        end
    endgenerate

    // Pipeline process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg      <= 8'd0;
            mul_b_reg      <= 8'd0;
            mul_en_out_reg <= 8'd0;
            sum_stage1     <= 16'd0;
            sum_stage2     <= 16'd0;
            sum_stage3     <= 16'd0;
            sum_stage4     <= 16'd0;
            sum_stage5     <= 16'd0;
            sum_stage6     <= 16'd0;
            sum_stage7     <= 16'd0;
            mul_out_reg    <= 16'd0;
        end else begin
            // Latch inputs when enabled
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end

            // Shift enable pipeline register and insert mul_en_in at LSB
            mul_en_out_reg <= {mul_en_out_reg[6:0], mul_en_in};

            // Pipeline summation of partial products stepwise to spread addition over clock cycles
            // Stage 1: sum partial_products[0] and partial_products[1]
            sum_stage1 <= partial_products[0] + partial_products[1];

            // Stage 2: sum from stage1 + partial_products[2]
            sum_stage2 <= sum_stage1 + partial_products[2];

            // Stage 3: sum from stage2 + partial_products[3]
            sum_stage3 <= sum_stage2 + partial_products[3];

            // Stage 4: sum from stage3 + partial_products[4]
            sum_stage4 <= sum_stage3 + partial_products[4];

            // Stage 5: sum from stage4 + partial_products[5]
            sum_stage5 <= sum_stage4 + partial_products[5];

            // Stage 6: sum from stage5 + partial_products[6]
            sum_stage6 <= sum_stage5 + partial_products[6];

            // Stage 7: sum from stage6 + partial_products[7]
            sum_stage7 <= sum_stage6 + partial_products[7];

            // Final product register updated last pipeline stage
            mul_out_reg <= sum_stage7;
        end
    end

    // Output enable is the MSB of the enable pipeline register (indicates output is valid)
    assign mul_en_out = mul_en_out_reg[7];

    // Output product is valid only when mul_en_out is asserted, else zero
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule