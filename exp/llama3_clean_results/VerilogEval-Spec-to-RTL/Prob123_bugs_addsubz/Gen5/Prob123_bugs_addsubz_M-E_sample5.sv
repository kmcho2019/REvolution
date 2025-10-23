module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] b_inverted;
    assign b_inverted = ~b + 1;

    always @(*) begin
        if (do_sub) begin
            out = a + b_inverted;
        end else begin
            out = a + b;
        end
        result_is_zero = (out == 8'd0)? 1 : 0;
    end

endmodule