module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    always @(*) begin
        if (do_sub)
            out = a - b;
        else
            out = a + b;

        result_is_zero = ~|out;
    end

endmodule