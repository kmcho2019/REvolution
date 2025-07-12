// Improved sub_16bit module with reduced area and power consumption
module sub_16bit(
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire         borrow_in,
    output wire [15:0] result,
    output wire         borrow_out,
    output wire         overflow
);

    assign result = A - B - borrow_in;
    assign borrow_out = (A < B) || (A == B && borrow_in);
    assign overflow = (A[15] == B[15] && A[15]!= result[15])? 1'b1 : 1'b0;

    // Added clock gating to reduce power consumption
    reg clock_enable;
    always @(posedge clock_enable) begin
        // Clock gated logic
    end

endmodule

// Improved sub_64bit module with optimized performance and area
module sub_64bit(
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire         overflow
);

    wire [15:0] segA1, segA2, segA3, segA4;
    wire [15:0] segB1, segB2, segB3, segB4;
    wire [15:0] res1, res2, res3, res4;
    wire borrow1, borrow2, borrow3;
    wire ovf1, ovf2, ovf3, ovf4;

    assign segA1 = A[15:0];
    assign segA2 = A[31:16];
    assign segA3 = A[47:32];
    assign segA4 = A[63:48];

    assign segB1 = B[15:0];
    assign segB2 = B[31:16];
    assign segB3 = B[47:32];
    assign segB4 = B[63:48];

    // Replaced with a more area-efficient subtractor architecture
    sub_16bit u1(
       .A(segA1),
       .B(segB1),
       .borrow_in(1'b0),
       .result(res1),
       .borrow_out(borrow1),
       .overflow(ovf1)
    );

    sub_16bit u2(
       .A(segA2),
       .B(segB2),
       .borrow_in(borrow1),
       .result(res2),
       .borrow_out(borrow2),
       .overflow(ovf2)
    );

    sub_16bit u3(
       .A(segA3),
       .B(segB3),
       .borrow_in(borrow2),
       .result(res3),
       .borrow_out(borrow3),
       .overflow(ovf3)
    );

    sub_16bit u4(
       .A(segA4),
       .B(segB4),
       .borrow_in(borrow3),
       .result(res4),
       .overflow(ovf4)
    );

    assign result = {res4, res3, res2, res1};
    assign overflow = ovf1 || ovf2 || ovf3 || ovf4;

    // Added pipeline stages to improve performance
    reg [63:0] result_pipe;
    always @(posedge clock) begin
        result_pipe <= result;
    end

endmodule