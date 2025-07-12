module multi_pipe_8bit (
    input         clk,
    input         rst_n,
    input         mul_en_in,
    input  [7:0]  mul_a,
    input  [7:0]  mul_b,
    output        mul_en_out,
    output [15:0] mul_out
);

// Pipeline stage enable shift register to track valid data through pipeline
reg [4:0] mul_en_pipe;

// Stage 0 registers: latch inputs on mul_en_in
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_pipe <= 5'b0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else begin
        // Shift in current enable
        mul_en_pipe <= {mul_en_pipe[3:0], mul_en_in};

        // Latch inputs only when mul_en_in is asserted
        if(mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Stage 1: Generate 8 partial products (each 16-bit shifted appropriately)
wire [15:0] partial_products [7:0];
genvar i;
generate
    for(i=0; i<8; i=i+1) begin : gen_partial_products
        // If mul_b_reg[i] is 1, partial product is mul_a_reg shifted i; else zero
        assign partial_products[i] = mul_b_reg[i] ? ( {8'd0, mul_a_reg} << i ) : 16'd0;
    end
endgenerate

// Stage 2: Sum partial products in pairs, registers to pipeline
reg [15:0] sum_pair0, sum_pair1, sum_pair2, sum_pair3;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_pair0 <= 16'd0;
        sum_pair1 <= 16'd0;
        sum_pair2 <= 16'd0;
        sum_pair3 <= 16'd0;
    end else begin
        sum_pair0 <= partial_products[0] + partial_products[1];
        sum_pair1 <= partial_products[2] + partial_products[3];
        sum_pair2 <= partial_products[4] + partial_products[5];
        sum_pair3 <= partial_products[6] + partial_products[7];
    end
end

// Stage 3: Sum results of pairs in pairs with registers
reg [15:0] sum_stage3_0, sum_stage3_1;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage3_0 <= 16'd0;
        sum_stage3_1 <= 16'd0;
    end else begin
        sum_stage3_0 <= sum_pair0 + sum_pair1;
        sum_stage3_1 <= sum_pair2 + sum_pair3;
    end
end

// Stage 4: Final sum, register output
reg [15:0] mul_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'd0;
    end else begin
        mul_out_reg <= sum_stage3_0 + sum_stage3_1;
    end
end

// Output enable is the last bit in pipeline register
assign mul_en_out = mul_en_pipe[4];

// Output zero if enable not active
assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule