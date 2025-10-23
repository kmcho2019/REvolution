module TopModule (
    input  [2:0] a,
    input  [2:0] b,
    output reg [2:0] out_or_bitwise,
    output reg       out_or_logical,
    output reg [5:0] out_not
);

    integer i;
    reg tmp_logical_or;

    always @* begin
        // Manual bitwise OR
        for (i = 0; i < 3; i = i + 1) begin
            out_or_bitwise[i] = a[i] | b[i];
        end

        // Manual logical OR over all bits of a and b
        tmp_logical_or = 1'b0;
        for (i = 0; i < 3; i = i + 1) begin
            tmp_logical_or = tmp_logical_or | a[i] | b[i];
        end
        out_or_logical = tmp_logical_or;

        // Concatenate inverted vectors: ~b as upper half, ~a as lower half
        out_not = { ~b, ~a };
    end

endmodule