module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    always @(*) begin
        if (do_sub == 1'b0)
            out = a + b;
        else
            out = a - b;

        // Correct zero flag: 1 if out is zero, 0 otherwise
        if (~|out)
            result_is_zero = 1'b1;
        else
            result_is_zero = 1'b0;
    end

endmodule