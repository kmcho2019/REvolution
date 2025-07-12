module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

// Define the 4x16 multiplier module
module mult_4x16(
    input [3:0] a,
    input [15:0] b,
    output [19:0] y
);
    assign y = a * b;
endmodule

// Define the tree-like adder module
module adder_tree(
    input [19:0] a,
    input [19:0] b,
    output [20:0] y
);
    assign y = a + b;
endmodule

// Define the partial product aligner module
module pp_align(
    input [19:0] a,
    input [2:0] shift,
    output [23:0] y
);
    assign y = a << shift;
endmodule

reg [3:0] ain_seg1, ain_seg2, ain_seg3, ain_seg4;
reg [15:0] bin_reg;
reg [19:0] pp1, pp2, pp3, pp4;
reg [20:0] acc1, acc2;
reg [23:0] aligned_pp1, aligned_pp2, aligned_pp3, aligned_pp4;
reg [31:0] result;

always @(posedge clk) begin
    if (!rst_n) begin
        // Initialize registers
        ain_seg1 <= 4'd0;
        ain_seg2 <= 4'd0;
        ain_seg3 <= 4'd0;
        ain_seg4 <= 4'd0;
        bin_reg <= 16'd0;
        pp1 <= 20'd0;
        pp2 <= 20'd0;
        pp3 <= 20'd0;
        pp4 <= 20'd0;
        acc1 <= 21'd0;
        acc2 <= 21'd0;
        aligned_pp1 <= 24'd0;
        aligned_pp2 <= 24'd0;
        aligned_pp3 <= 24'd0;
        aligned_pp4 <= 24'd0;
        result <= 32'd0;
    end else if (start) begin
        // Segment the input
        ain_seg1 <= ain[3:0];
        ain_seg2 <= ain[7:4];
        ain_seg3 <= ain[11:8];
        ain_seg4 <= ain[15:12];
        bin_reg <= bin;

        // Generate partial products
        mult_4x16 mult1(ain_seg1, bin_reg, pp1);
        mult_4x16 mult2(ain_seg2, bin_reg, pp2);
        mult_4x16 mult3(ain_seg3, bin_reg, pp3);
        mult_4x16 mult4(ain_seg4, bin_reg, pp4);

        // Align partial products
        pp_align align1(pp1, 3'd0, aligned_pp1);
        pp_align align2(pp2, 3'd4, aligned_pp2);
        pp_align align3(pp3, 3'd8, aligned_pp3);
        pp_align align4(pp4, 3'd12, aligned_pp4);

        // Accumulate partial products
        adder_tree add1(aligned_pp1, aligned_pp2, acc1);
        adder_tree add2(aligned_pp3, aligned_pp4, acc2);
        adder_tree add3(acc1, acc2, result);

        // Set done flag
        done <= 1'b1;
    end else begin
        // Reset registers
        ain_seg1 <= 4'd0;
        ain_seg2 <= 4'd0;
        ain_seg3 <= 4'd0;
        ain_seg4 <= 4'd0;
        bin_reg <= 16'd0;
        pp1 <= 20'd0;
        pp2 <= 20'd0;
        pp3 <= 20'd0;
        pp4 <= 20'd0;
        acc1 <= 21'd0;
        acc2 <= 21'd0;
        aligned_pp1 <= 24'd0;
        aligned_pp2 <= 24'd0;
        aligned_pp3 <= 24'd0;
        aligned_pp4 <= 24'd0;
        result <= 32'd0;
        done <= 1'b0;
    end
end

assign yout = result;

endmodule