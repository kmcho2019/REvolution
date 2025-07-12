module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Instantiate three parallel reduction trees
    ReductionTree #(.WIDTH(100), .OP("AND")) and_tree (.in(in), .out(out_and));
    ReductionTree #(.WIDTH(100), .OP("OR" )) or_tree  (.in(in), .out(out_or));
    ReductionTree #(.WIDTH(100), .OP("XOR")) xor_tree (.in(in), .out(out_xor));

endmodule


// ReductionTree module reduces an input vector of WIDTH bits to 1 bit
// by recursively combining pairs of bits using the specified OP: "AND", "OR", or "XOR".
module ReductionTree #(parameter WIDTH = 1, parameter OP = "AND") (
    input  [WIDTH-1:0] in,
    output             out
);

    // If WIDTH=1, just output the single input bit (base case)
    generate
        if (WIDTH == 1) begin
            assign out = in[0];
        end else begin
            // Calculate half-width, rounding up
            localparam HALF = (WIDTH + 1) / 2;

            // Prepare array for intermediate results after one reduction stage
            wire [HALF-1:0] stage_out;

            genvar i;
            // For each pair or single bit, combine according to OP
            for (i = 0; i < HALF; i = i + 1) begin : pair_combine
                // If upper bit exists, combine pair; else pass through single bit
                if ((2*i + 1) < WIDTH) begin
                    assign stage_out[i] = comb_op(in[2*i], in[2*i + 1]);
                end else begin
                    assign stage_out[i] = in[2*i];
                end
            end

            // Recursive instantiation of next stage to further reduce stage_out to 1 bit
            ReductionTree #(.WIDTH(HALF), .OP(OP)) next_stage (
                .in(stage_out),
                .out(out)
            );
        end
    endgenerate


    // Function that performs the selected bitwise operation on two bits
    function automatic logic comb_op(input logic a, input logic b);
        begin
            if      (OP == "AND") comb_op = a & b;
            else if (OP == "OR" ) comb_op = a | b;
            else if (OP == "XOR") comb_op = a ^ b;
            else                  comb_op = 1'bx;  // invalid OP string
        end
    endfunction

endmodule