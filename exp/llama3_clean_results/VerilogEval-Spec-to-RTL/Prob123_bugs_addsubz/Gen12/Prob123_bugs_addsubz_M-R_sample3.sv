module TopModule (
    input logic do_sub,
    input [7:0] a,
    input [7:0] b,
    output logic [7:0] out,
    output logic result_is_zero
);

    assign out = do_sub ? (a - b) : (a + b);

    always @(*) begin
        if (out == 0) begin
            result_is_zero = 1;
        end else begin
            result_is_zero = 0;
        end
    end

endmodule