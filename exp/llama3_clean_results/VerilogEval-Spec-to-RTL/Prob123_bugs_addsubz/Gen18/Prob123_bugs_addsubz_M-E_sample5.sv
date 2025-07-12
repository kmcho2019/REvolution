module hybrid_addsub_zflag #
(
    parameter WIDTH = 8,
    parameter CHUNK_WIDTH = 4
)
(
    input do_sub,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output reg [WIDTH-1:0] out,
    output reg result_is_zero
);

    wire [WIDTH-1:0] b_invert;
    assign b_invert = do_sub ? ~b : b;

    wire carry_in;
    assign carry_in = do_sub ? 1'b1 : 1'b0;

    reg [WIDTH-1:0] sum;
    reg carry_out;

    // Divide the input operands into chunks
    wire [CHUNK_WIDTH-1:0] a_chunk1;
    wire [CHUNK_WIDTH-1:0] b_chunk1;
    wire [CHUNK_WIDTH-1:0] a_chunk2;
    wire [CHUNK_WIDTH-1:0] b_chunk2;

    assign a_chunk1 = a[CHUNK_WIDTH-1:0];
    assign b_chunk1 = b_invert[CHUNK_WIDTH-1:0];
    assign a_chunk2 = a[WIDTH-1:CHUNK_WIDTH];
    assign b_chunk2 = b_invert[WIDTH-1:CHUNK_WIDTH];

    // Ripple-carry adder for each chunk
    wire [CHUNK_WIDTH-1:0] sum_chunk1;
    wire carry_chunk1;
    wire [CHUNK_WIDTH-1:0] sum_chunk2;
    wire carry_chunk2;

    always @(*) begin
        {carry_chunk1, sum_chunk1} = a_chunk1 + b_chunk1 + carry_in;
        {carry_chunk2, sum_chunk2} = a_chunk2 + b_chunk2 + carry_chunk1;
    end

    // Combine the results of each chunk
    always @(*) begin
        sum[CHUNK_WIDTH-1:0] = sum_chunk1;
        sum[WIDTH-1:CHUNK_WIDTH] = sum_chunk2;
        carry_out = carry_chunk2;
    end

    // Zero detection using a tree of AND gates
    reg zero_chunk1;
    reg zero_chunk2;

    always @(*) begin
        zero_chunk1 = ~(| sum_chunk1);
        zero_chunk2 = ~(| sum_chunk2);
    end

    assign result_is_zero = zero_chunk1 & zero_chunk2;

    assign out = sum;

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    hybrid_addsub_zflag #(.WIDTH(8), .CHUNK_WIDTH(4)) u_addsub (
        .do_sub(do_sub),
        .a(a),
        .b(b),
        .out(out),
        .result_is_zero(result_is_zero)
    );

endmodule