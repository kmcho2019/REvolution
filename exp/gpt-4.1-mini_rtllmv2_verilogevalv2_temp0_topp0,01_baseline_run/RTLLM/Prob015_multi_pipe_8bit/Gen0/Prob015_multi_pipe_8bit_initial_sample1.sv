module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

// Pipeline registers for enable signal (8 stages to match pipeline depth)
reg [7:0] mul_en_out_reg;

// Input registers for multiplicand and multiplier
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial products wires (8 partial products, each shifted accordingly)
wire [15:0] temp [7:0];

// Registers for partial sums (pipeline stages)
reg [15:0] sum1; // sum of partial products 0 and 1
reg [15:0] sum2; // sum of partial products 2 and 3
reg [15:0] sum3; // sum of partial products 4 and 5
reg [15:0] sum4; // sum of partial products 6 and 7

reg [15:0] sum5; // sum of sum1 and sum2
reg [15:0] sum6; // sum of sum3 and sum4

reg [15:0] mul_out_reg;

// Generate partial products by ANDing mul_a with each bit of mul_b and shifting
genvar i;
generate
    for (i=0; i<8; i=i+1) begin : gen_partial_products
        assign temp[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Pipeline process
always @(posedge clk) begin
    if (!rst_n) begin
        mul_en_out_reg <= 8'd0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        sum1 <= 16'd0;
        sum2 <= 16'd0;
        sum3 <= 16'd0;
        sum4 <= 16'd0;
        sum5 <= 16'd0;
        sum6 <= 16'd0;
        mul_out_reg <= 16'd0;
    end else begin
        // Pipeline enable signal
        mul_en_out_reg <= {mul_en_out_reg[6:0], mul_en_in};

        // Register inputs only when mul_en_in is high
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Stage 1: sum pairs of partial products
        sum1 <= temp[0] + temp[1];
        sum2 <= temp[2] + temp[3];
        sum3 <= temp[4] + temp[5];
        sum4 <= temp[6] + temp[7];

        // Stage 2: sum pairs of sums
        sum5 <= sum1 + sum2;
        sum6 <= sum3 + sum4;

        // Stage 3: final sum
        mul_out_reg <= sum5 + sum6;
    end
end

// Output enable is the MSB of mul_en_out_reg (8 cycles latency)
assign mul_en_out = mul_en_out_reg[7];

// Output product is valid only when mul_en_out is high
assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule