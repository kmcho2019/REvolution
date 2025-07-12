module fixed_point_subtractor #(
    parameter integer N = 16,
    parameter integer Q = 8
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output reg  signed [N-1:0] c
);

    always @(*) begin
        c = a - b;
        if (c == 0)
            c = {1'b0, {(N-1){1'b0}}};
    end

endmodule