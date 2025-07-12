module hybrid_addsub_zflag #
(
    parameter WIDTH = 8,
    parameter SEGMENT_SIZE = 4
)
(
    input do_sub,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output reg [WIDTH-1:0] out,
    output reg result_is_zero
);

    // Divide input operands into segments
    wire [SEGMENT_SIZE-1:0] a_segment1;
    wire [SEGMENT_SIZE-1:0] a_segment2;
    assign a_segment1 = a[WIDTH-1:WIDTH-SEGMENT_SIZE];
    assign a_segment2 = a[SEGMENT_SIZE-1:0];

    wire [SEGMENT_SIZE-1:0] b_segment1;
    wire [SEGMENT_SIZE-1:0] b_segment2;
    assign b_segment1 = b[WIDTH-1:WIDTH-SEGMENT_SIZE];
    assign b_segment2 = b[SEGMENT_SIZE-1:0];

    // Perform addition or subtraction on each segment
    reg [SEGMENT_SIZE-1:0] sum_segment1;
    reg [SEGMENT_SIZE-1:0] sum_segment2;
    reg carry_out_segment1;
    reg carry_out_segment2;

    always @(*) begin
        if (do_sub) begin
            {carry_out_segment1, sum_segment1} = a_segment1 - b_segment1;
            {carry_out_segment2, sum_segment2} = a_segment2 - b_segment2 + carry_out_segment1;
        end else begin
            {carry_out_segment1, sum_segment1} = a_segment1 + b_segment1;
            {carry_out_segment2, sum_segment2} = a_segment2 + b_segment2 + carry_out_segment1;
        end
    end

    // Combine results using ripple-carry adder
    reg [WIDTH-1:0] sum;
    assign sum = {sum_segment1, sum_segment2};

    // Zero detection using hierarchical priority encoder
    reg segment1_zero;
    reg segment2_zero;
    assign segment1_zero = ~(| sum_segment1);
    assign segment2_zero = ~(| sum_segment2);

    assign result_is_zero = segment1_zero && segment2_zero;

    assign out = sum;

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    hybrid_addsub_zflag #(.WIDTH(8), .SEGMENT_SIZE(4)) u_addsub (
        .do_sub(do_sub),
        .a(a),
        .b(b),
        .out(out),
        .result_is_zero(result_is_zero)
    );

endmodule