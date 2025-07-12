module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_modified;
    wire [8:0] sum_ext;

    // Conditionally invert B for subtraction (two's complement approach)
    assign b_modified = b ^ {8{do_sub}};

    // Add with carry-in = do_sub to implement subtraction as addition of two's complement
    assign sum_ext = {1'b0, a} + {1'b0, b_modified} + do_sub;

    always @(*) begin
        out = sum_ext[7:0];
        result_is_zero = ~|sum_ext[7:0];  // reduction NOR to detect zero
    end

endmodule