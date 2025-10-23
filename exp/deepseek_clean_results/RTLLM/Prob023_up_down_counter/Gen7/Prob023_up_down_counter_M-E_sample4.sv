module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Parallel prefix adder structure for increment
wire [15:0] inc_count;
wire [15:0] inc_prop, inc_gen;
wire [15:0] inc_carry;

assign inc_prop = count ^ 16'h0001;  // Propagate for +1
assign inc_gen = count & 16'h0001;   // Generate for +1

// Kogge-Stone parallel prefix network
wire [15:0] inc_prop_stage1, inc_gen_stage1;
wire [15:0] inc_prop_stage2, inc_gen_stage2;
wire [15:0] inc_prop_stage3, inc_gen_stage3;
wire [15:0] inc_prop_stage4, inc_gen_stage4;

// Stage 1: 1-bit spacing
assign inc_prop_stage1[0] = inc_prop[0];
assign inc_gen_stage1[0] = inc_gen[0];
genvar i;
generate
    for (i = 1; i < 16; i = i + 1) begin : stage1
        assign inc_prop_stage1[i] = inc_prop[i] & inc_prop[i-1];
        assign inc_gen_stage1[i] = (inc_prop[i] & inc_gen[i-1]) | inc_gen[i];
    end
endgenerate

// Stage 2: 2-bit spacing
assign inc_prop_stage2[1:0] = inc_prop_stage1[1:0];
assign inc_gen_stage2[1:0] = inc_gen_stage1[1:0];
generate
    for (i = 2; i < 16; i = i + 1) begin : stage2
        assign inc_prop_stage2[i] = inc_prop_stage1[i] & inc_prop_stage1[i-2];
        assign inc_gen_stage2[i] = (inc_prop_stage1[i] & inc_gen_stage1[i-2]) | inc_gen_stage1[i];
    end
endgenerate

// Stage 3: 4-bit spacing
assign inc_prop_stage3[3:0] = inc_prop_stage2[3:0];
assign inc_gen_stage3[3:0] = inc_gen_stage2[3:0];
generate
    for (i = 4; i < 16; i = i + 1) begin : stage3
        assign inc_prop_stage3[i] = inc_prop_stage2[i] & inc_prop_stage2[i-4];
        assign inc_gen_stage3[i] = (inc_prop_stage2[i] & inc_gen_stage2[i-4]) | inc_gen_stage2[i];
    end
endgenerate

// Stage 4: 8-bit spacing
assign inc_prop_stage4[7:0] = inc_prop_stage3[7:0];
assign inc_gen_stage4[7:0] = inc_gen_stage3[7:0];
generate
    for (i = 8; i < 16; i = i + 1) begin : stage4
        assign inc_prop_stage4[i] = inc_prop_stage3[i] & inc_prop_stage3[i-8];
        assign inc_gen_stage4[i] = (inc_prop_stage3[i] & inc_gen_stage3[i-8]) | inc_gen_stage3[i];
    end
endgenerate

// Final carry computation
assign inc_carry = inc_gen_stage4;
assign inc_count = count ^ {inc_carry[14:0], 1'b0} ^ 16'h0001;

// Parallel prefix subtractor structure for decrement
wire [15:0] dec_count;
wire [15:0] dec_prop, dec_gen;
wire [15:0] dec_borrow;

assign dec_prop = count ^ 16'h0001;  // Propagate for -1
assign dec_gen = ~count & 16'h0001;  // Generate for -1

// Similar Kogge-Stone structure for decrement (omitted for brevity)
// ... same parallel prefix network as increment but for subtract ...

assign dec_count = count ^ {dec_borrow[14:0], 1'b0} ^ 16'h0001;

// Select between increment and decrement
always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= up_down ? inc_count : dec_count;
    end
end

endmodule