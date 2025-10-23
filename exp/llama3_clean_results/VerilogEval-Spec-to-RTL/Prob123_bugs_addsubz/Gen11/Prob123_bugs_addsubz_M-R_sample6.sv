module TopModule (
    input logic do_sub,
    input [7:0] a,
    input [7:0] b,
    output logic [7:0] out,
    output logic result_is_zero
);

    always @(*) begin
        if (do_sub) begin
            out = a - b;
        end else begin
            out = a + b;
        end
        result_is_zero = ~(| out);
    end

endmodule