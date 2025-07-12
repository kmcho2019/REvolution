module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] add_result;
    wire [7:0] sub_result;

    // Perform addition and subtraction concurrently
    assign add_result = a + b;
    assign sub_result = a - b;

    // Select the result based on the do_sub signal
    assign out = do_sub ? sub_result : add_result;

    // Check if the result is zero
    always @(*) begin
        if (out == 8'd0) begin
            result_is_zero = 1'b1;
        end else begin
            result_is_zero = 1'b0;
        end
    end

endmodule