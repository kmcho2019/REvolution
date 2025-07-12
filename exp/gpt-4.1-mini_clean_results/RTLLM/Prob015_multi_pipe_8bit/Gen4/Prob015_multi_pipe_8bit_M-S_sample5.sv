module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Registers to hold inputs and enable signal
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg       mul_en_reg;

// Partial products wires
wire [15:0] partial_products [7:0];

// Input capture
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        mul_en_reg <= 1'b0;
    end else begin
        mul_en_reg <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Generate partial products by shifting and AND operation
genvar i;
generate
    for (i=0; i<8; i=i+1) begin : gen_pp
        assign partial_products[i] = (mul_b_reg[i]) ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Sum all partial products in one pipeline stage
reg [15:0] mul_out_reg;
reg        mul_en_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'd0;
        mul_en_out_reg <= 1'b0;
    end else begin
        // Accumulate partial products only if input was enabled previous cycle
        if (mul_en_reg) begin
            mul_out_reg <= partial_products[0] + partial_products[1] + partial_products[2]
                         + partial_products[3] + partial_products[4] + partial_products[5]
                         + partial_products[6] + partial_products[7];
        end else begin
            mul_out_reg <= 16'd0;
        end
        mul_en_out_reg <= mul_en_reg;
    end
end

// Output enable and product output assignment
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out <= 16'd0;
    end else begin
        mul_en_out <= mul_en_out_reg;
        mul_out <= mul_en_out_reg ? mul_out_reg : 16'd0;
    end
end

endmodule