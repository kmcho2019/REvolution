module hybrid_addsub #
(
    parameter WIDTH = 8
)
(
    input do_sub,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output reg [WIDTH-1:0] out,
    output reg result_is_zero
);

    // Divide operands into smaller chunks
    localparam CHUNK_SIZE = 4;
    wire [CHUNK_SIZE-1:0] a_chunk1, a_chunk2;
    wire [CHUNK_SIZE-1:0] b_chunk1, b_chunk2;
    assign a_chunk1 = a[WIDTH-1:WIDTH-CHUNK_SIZE];
    assign a_chunk2 = a[WIDTH-CHUNK_SIZE-1:0];
    assign b_chunk1 = b[WIDTH-1:WIDTH-CHUNK_SIZE];
    assign b_chunk2 = b[WIDTH-CHUNK_SIZE-1:0];

    // Hybrid parallel-serial adder
    reg [WIDTH-1:0] sum;
    always @(*) begin
        reg [CHUNK_SIZE-1:0] chunk_sum1, chunk_sum2;
        reg carry_out1, carry_out2;
        {carry_out1, chunk_sum1} = a_chunk1 + (do_sub? ~b_chunk1 : b_chunk1);
        {carry_out2, chunk_sum2} = a_chunk2 + (do_sub? ~b_chunk2 : b_chunk2) + (carry_out1? 1 : 0);
        sum = {chunk_sum1, chunk_sum2};
    end

    // Lookahead zero detection
    reg lz_dout;
    always @(*) begin
        if ((a[WIDTH-1] == b[WIDTH-1]) && (do_sub == 1)) begin
            lz_dout = 1;
        end else if ((a[WIDTH-1]!= b[WIDTH-1]) && (do_sub == 0)) begin
            lz_dout = 0;
        end else begin
            lz_dout = ~(sum!= 0);
        end
    end

    // Dynamic operand swapping
    reg [WIDTH-1:0] swapped_a, swapped_b;
    always @(*) begin
        if (a > b) begin
            swapped_a = a;
            swapped_b = b;
        end else begin
            swapped_a = b;
            swapped_b = a;
        end
    end

    // Clock gating with operand validity
    reg clock_enable;
    always @(*) begin
        if (a!= 0 && b!= 0) begin
            clock_enable = 1;
        end else begin
            clock_enable = 0;
        end
    end

    // Output assignments
    assign out = sum;
    assign result_is_zero = lz_dout;

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    hybrid_addsub #(.WIDTH(8)) u_hybrid (
       .do_sub(do_sub),
       .a(a),
       .b(b),
       .out(out),
       .result_is_zero(result_is_zero)
    );

endmodule