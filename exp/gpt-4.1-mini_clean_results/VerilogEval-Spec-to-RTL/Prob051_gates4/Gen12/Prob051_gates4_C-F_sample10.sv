module TopModule #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] in,
    output reg         out_and,
    output reg         out_or,
    output reg         out_xor
);

    integer i;
    always @(*) begin
        // Initialize outputs for reduction
        out_and = 1'b1;
        out_or  = 1'b0;
        out_xor = 1'b0;

        // Perform reduction with explicit for-loop for clarity and scalability
        for (i = 0; i < WIDTH; i = i + 1) begin
            out_and = out_and & in[i];
            out_or  = out_or  | in[i];
            out_xor = out_xor ^ in[i];
        end
    end

endmodule