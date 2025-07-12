module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

reg [3:0] mul_en_out_reg; // 4-stage enable pipeline
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

wire [15:0] partial_products [7:0];
integer i;

// Sample inputs and enable pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 4'b0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else begin
        mul_en_out_reg <= {mul_en_out_reg[2:0], mul_en_in};
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Generate partial products by ANDing mul_a_reg with each mul_b_reg bit and shifting
generate
    genvar idx;
    for (idx = 0; idx < 8; idx = idx +1) begin : gen_partial_products
        assign partial_products[idx] = mul_b_reg[idx] ? (mul_a_reg << idx) : 16'd0;
    end
endgenerate

// Sum of all partial products
reg [15:0] sum_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg <= 16'd0;
    end else if (mul_en_out_reg[2]) begin
        // Combine all partial products at once in a single cycle
        sum_reg <= partial_products[0] + partial_products[1] + partial_products[2] +
                   partial_products[3] + partial_products[4] + partial_products[5] +
                   partial_products[6] + partial_products[7];
    end else begin
        sum_reg <= 16'd0;
    end
end

// Final stage register to hold product output
reg [15:0] mul_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'd0;
    end else if (mul_en_out_reg[3]) begin
        mul_out_reg <= sum_reg;
    end else begin
        mul_out_reg <= 16'd0;
    end
end

// Output enable signal registered from pipeline MSB
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        mul_en_out <= 1'b0;
    else
        mul_en_out <= mul_en_out_reg[3];
end

// Output mux: assign product when enabled, else zero
always @(*) begin
    mul_out = mul_en_out ? mul_out_reg : 16'd0;
end

endmodule