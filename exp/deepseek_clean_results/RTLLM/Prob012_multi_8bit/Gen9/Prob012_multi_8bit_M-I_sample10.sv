module multi_8bit (
    input clk,
    input reset,
    input start,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product,
    output reg done
);

    reg [2:0] bit_counter;
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accumulator;
    reg processing;

    // Carry-select adder for better performance
    wire [15:0] adder_out;
    carry_select_adder csa (
        .a(accumulator),
        .b({8'b0, multiplicand} << bit_counter),
        .sum(adder_out)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            product <= 16'b0;
            done <= 1'b0;
            processing <= 1'b0;
        end else if (start && !processing) begin
            // Initialize registers
            multiplicand <= A;
            multiplier <= B;
            accumulator <= 16'b0;
            bit_counter <= 3'b0;
            processing <= 1'b1;
            done <= 1'b0;
        end else if (processing) begin
            if (multiplier[bit_counter]) begin
                accumulator <= adder_out;
            end

            // Early termination if remaining bits are zero
            if (bit_counter == 3'd7 || &(~multiplier[7:bit_counter+1])) begin
                product <= accumulator;
                done <= 1'b1;
                processing <= 1'b0;
            end else begin
                bit_counter <= bit_counter + 1;
            end
        end
    end

endmodule

module carry_select_adder (
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    // 4-bit carry-select adder blocks for better performance
    wire [3:0] sum0, sum1_0, sum1_1;
    wire [3:0] sum2_0, sum2_1;
    wire [3:0] sum3_0, sum3_1;
    wire c4, c8, c12;

    // First 4-bit block (ripple carry)
    assign {c4, sum[3:0]} = a[3:0] + b[3:0];

    // Second 4-bit block (carry-select)
    assign sum1_0 = a[7:4] + b[7:4];
    assign sum1_1 = a[7:4] + b[7:4] + 1;
    assign sum[7:4] = c4 ? sum1_1 : sum1_0;
    assign c8 = c4 ? (|(a[7:4] & b[7:4]) | (&(a[7:4] | b[7:4])) : (|(a[7:4] & b[7:4]));

    // Third 4-bit block (carry-select)
    assign sum2_0 = a[11:8] + b[11:8];
    assign sum2_1 = a[11:8] + b[11:8] + 1;
    assign sum[11:8] = c8 ? sum2_1 : sum2_0;
    assign c12 = c8 ? (|(a[11:8] & b[11:8])) | (&(a[11:8] | b[11:8])) : (|(a[11:8] & b[11:8]));

    // Fourth 4-bit block (carry-select)
    assign sum3_0 = a[15:12] + b[15:12];
    assign sum3_1 = a[15:12] + b[15:12] + 1;
    assign sum[15:12] = c12 ? sum3_1 : sum3_0;
endmodule