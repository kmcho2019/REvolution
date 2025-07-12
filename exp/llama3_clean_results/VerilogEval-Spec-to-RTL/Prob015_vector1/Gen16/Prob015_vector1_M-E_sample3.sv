module TopModule #(
    parameter INPUT_WIDTH = 16,
    parameter SPLIT_POINT = 8
) (
    input  [INPUT_WIDTH-1:0] in,
    output [SPLIT_POINT-1:0] out_hi,
    output [INPUT_WIDTH-SPLIT_POINT-1:0] out_lo
);

    // Recursive module for splitting the input
    module recursive_split #(
        parameter WIDTH_IN = 16,
        parameter WIDTH_OUT = 8
    ) (
        input  [WIDTH_IN-1:0] in,
        output [WIDTH_OUT-1:0] out_hi,
        output [WIDTH_IN-WIDTH_OUT-1:0] out_lo
    );

        // Base case: directly assign output bits
        if (WIDTH_OUT == 1) begin
            assign out_hi = in[WIDTH_IN-1];
            assign out_lo = in[WIDTH_IN-2];
        end else begin
            // Recursive case: split input into smaller parts
            wire [WIDTH_OUT/2-1:0] out_hi_lo;
            wire [WIDTH_IN-WIDTH_OUT/2-1:0] out_lo_lo;

            recursive_split #(
               .WIDTH_IN(WIDTH_OUT),
               .WIDTH_OUT(WIDTH_OUT/2)
            ) u_recursive_split_hi (
               .in(in[WIDTH_IN-1:WIDTH_IN-WIDTH_OUT]),
               .out_hi(out_hi[WIDTH_OUT-1:WIDTH_OUT/2]),
               .out_lo(out_hi_lo)
            );

            recursive_split #(
               .WIDTH_IN(WIDTH_IN-WIDTH_OUT),
               .WIDTH_OUT(WIDTH_IN-WIDTH_OUT/2)
            ) u_recursive_split_lo (
               .in(in[WIDTH_IN-WIDTH_OUT-1:0]),
               .out_hi(out_lo[WIDTH_IN-WIDTH_OUT-1:WIDTH_IN-WIDTH_OUT/2]),
               .out_lo(out_lo_lo)
            );

            // Assign output bits
            assign out_hi[WIDTH_OUT/2-1:0] = out_hi_lo;
            assign out_lo[WIDTH_IN-WIDTH_OUT/2-1:0] = out_lo_lo;
        end
    endmodule

    // Instantiate the recursive module
    recursive_split #(
       .WIDTH_IN(INPUT_WIDTH),
       .WIDTH_OUT(SPLIT_POINT)
    ) u_recursive_split (
       .in(in),
       .out_hi(out_hi),
       .out_lo(out_lo)
    );

endmodule