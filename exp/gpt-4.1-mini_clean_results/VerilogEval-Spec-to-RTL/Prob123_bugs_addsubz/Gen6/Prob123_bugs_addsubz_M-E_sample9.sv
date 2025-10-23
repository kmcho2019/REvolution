module TopModule (
    input  wire       do_sub,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output reg  [7:0] out,
    output reg        result_is_zero
);

    always @(*) begin
        if (do_sub)
            out = a - b;
        else
            out = a + b;

        // Use reduction NOR to detect zero output correctly
        if (~|out)
            result_is_zero = 1'b1;
        else
            result_is_zero = 1'b0;
    end

endmodule