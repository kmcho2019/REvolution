module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] add_result;
    wire [7:0] sub_result;

    // Perform addition
    assign add_result = a + b;

    // Perform subtraction
    assign sub_result = a - b;

    always @(*) begin
        if (do_sub)
            out = sub_result;
        else
            out = add_result;

        result_is_zero = (out == 8'b0);
    end

endmodule