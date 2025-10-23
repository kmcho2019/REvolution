module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Stage 1 registers: capture inputs and mul_en_in
reg        en_stage1;
reg [7:0]  a_stage1;
reg [7:0]  b_stage1;

// Partial products for lower and upper 4-bit multiplications
// Stage 2 registers: partial sums from partial product accumulation
reg        en_stage2;
reg [11:0] pp_low;   // 8b mul 4b => max 12 bits (8*15=120 decimal fits 8 bits *4 bits)
reg [11:0] pp_high;  // 8b mul 4b shifted by 4 bits, max 12 bits

// Stage 3 registers: final addition and output enable
reg        en_stage3;
reg [15:0] product_stage3;

// ----------------------------------------------------------------------------
// Stage 1: Capture inputs and generate partial products for low and high nibbles
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        en_stage1 <= 1'b0;
        a_stage1 <= 8'd0;
        b_stage1 <= 8'd0;
    end else begin
        en_stage1 <= mul_en_in;
        if (mul_en_in) begin
            a_stage1 <= mul_a;
            b_stage1 <= mul_b;
        end
    end
end

// ----------------------------------------------------------------------------
// Functions to multiply 8-bit by 4-bit unsigned
// To keep synthesis friendly, implement combinational multiply for 8x4 bits via partial products
function [11:0] mult_8x4;
    input [7:0] a;
    input [3:0] b;
    integer i;
    reg [11:0] sum;
begin
    sum = 0;
    for (i=0; i<4; i=i+1) begin
        if (b[i]) sum = sum + (a << i);
    end
    mult_8x4 = sum;
end
endfunction

// Stage 2: Calculate partial sums for lower and upper 4 bits of mul_b, registered
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pp_low <= 12'd0;
        pp_high <= 12'd0;
        en_stage2 <= 1'b0;
    end else begin
        en_stage2 <= en_stage1;
        if (en_stage1) begin
            pp_low <= mult_8x4(a_stage1, b_stage1[3:0]);          // A * lower 4 bits of B
            pp_high <= mult_8x4(a_stage1, b_stage1[7:4]);         // A * upper 4 bits of B
        end else begin
            pp_low <= 12'd0;
            pp_high <= 12'd0;
        end
    end
end

// ----------------------------------------------------------------------------
// Stage 3: Final product assembly - shift pp_high by 4 bits and add to pp_low
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        product_stage3 <= 16'd0;
        en_stage3 <= 1'b0;
    end else begin
        en_stage3 <= en_stage2;
        if (en_stage2) begin
            // pp_high shifted left by 4 bits (multiply by 16)
            // Add pp_low and shifted pp_high to form full product
            product_stage3 <= {4'd0, pp_low} + ( {pp_high, 4'd0} );
        end else begin
            product_stage3 <= 16'd0;
        end
    end
end

// ----------------------------------------------------------------------------
// Output assignments with enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out <= 16'd0;
    end else begin
        mul_en_out <= en_stage3;
        mul_out <= (en_stage3) ? product_stage3 : 16'd0;
    end
end

endmodule