module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output  reg         mul_en_out,
    output  reg [15:0]  mul_out
);

    // Enable pipeline registers (3-stage)
    reg [2:0] en_pipe;
    // Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    // Final product register
    reg [15:0] mul_out_reg;

    integer i;
    wire [15:0] partial_products [7:0];
    wire [15:0] sum_partial;

    // Pipeline enable and input registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_pipe     <= 3'b0;
            mul_a_reg   <= 8'b0;
            mul_b_reg   <= 8'b0;
        end else begin
            en_pipe <= {en_pipe[1:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Generate partial products combinationally
    genvar idx;
    generate
        for (idx=0; idx<8; idx=idx+1) begin : gen_pp
            assign partial_products[idx] = mul_b_reg[idx] ? (mul_a_reg << idx) : 16'b0;
        end
    endgenerate

    // Sum all partial products combinationally
    assign sum_partial = partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3] +
                         partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7];

    // Register final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'b0;
            mul_en_out  <= 1'b0;
            mul_out     <= 16'b0;
        end else begin
            if (en_pipe[1]) begin
                mul_out_reg <= sum_partial;
            end else begin
                mul_out_reg <= 16'b0;
            end
            mul_en_out <= en_pipe[2];
            mul_out <= en_pipe[2] ? mul_out_reg : 16'b0;
        end
    end

endmodule