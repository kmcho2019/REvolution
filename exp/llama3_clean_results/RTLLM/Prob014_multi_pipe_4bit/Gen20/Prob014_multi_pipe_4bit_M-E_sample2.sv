module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

parameter size = 4;

// Modular partial product generator
module partial_product_gen(
    input [3:0] mul_a,  // multiplicand
    input [1:0] shift,  // shift amount
    output reg [7:0] partial_product  // generated partial product
);
    always @(*) begin
        if (shift == 2'd0) begin
            partial_product = {4'd0, mul_a};
        end else begin
            partial_product = {4'd0, mul_a} << shift;
        end
    end
endmodule

// Accumulator chain stage
module accumulator_stage(
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [7:0] in,  // input to be accumulated
    input [7:0] add,  // value to add
    output reg [7:0] out  // accumulated output
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out <= 8'd0;
        end else begin
            out <= out + add;
        end
    end
endmodule

// Dynamic shift register
reg [7:0] shift_reg;
always @(posedge clk) begin
    shift_reg <= {4'd0, mul_a};
end

// Accumulator chain
wire [7:0] pp0, pp1, pp2, pp3;
partial_product_gen pp_gen0(.mul_a(mul_a), .shift(2'd0), .partial_product(pp0));
partial_product_gen pp_gen1(.mul_a(mul_a), .shift(2'd1), .partial_product(pp1));
partial_product_gen pp_gen2(.mul_a(mul_a), .shift(2'd2), .partial_product(pp2));
partial_product_gen pp_gen3(.mul_a(mul_a), .shift(2'd3), .partial_product(pp3));

reg [7:0] acc_out0, acc_out1, acc_out2, acc_out3;
accumulator_stage acc_stage0(.clk(clk), .rst_n(rst_n), .in(8'd0), .add(mul_b[0] ? pp0 : 8'd0), .out(acc_out0));
accumulator_stage acc_stage1(.clk(clk), .rst_n(rst_n), .in(acc_out0), .add(mul_b[1] ? pp1 : 8'd0), .out(acc_out1));
accumulator_stage acc_stage2(.clk(clk), .rst_n(rst_n), .in(acc_out1), .add(mul_b[2] ? pp2 : 8'd0), .out(acc_out2));
accumulator_stage acc_stage3(.clk(clk), .rst_n(rst_n), .in(acc_out2), .add(mul_b[3] ? pp3 : 8'd0), .out(acc_out3));

// Final product output
always @(posedge clk) begin
    mul_out <= acc_out3;
end

endmodule