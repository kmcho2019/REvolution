module fixed_point_subtractor #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    wire [N-1:0] diff = a - b;

    always @* begin
        // Default: difference result
        c = diff;

        // If result is zero, explicitly set sign bit to 0
        if (diff == {N{1'b0}}) begin
            c[N-1] = 1'b0;
        end
    end

endmodule