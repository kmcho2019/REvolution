module fixed_point_subtractor #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    reg [N-1:0] res;

    always @* begin
        res = a - b;
        if (res == {N{1'b0}}) begin
            // Clear sign bit explicitly for zero result
            res = {1'b0, res[N-2:0]};
        end
    end

    assign c = res;

endmodule