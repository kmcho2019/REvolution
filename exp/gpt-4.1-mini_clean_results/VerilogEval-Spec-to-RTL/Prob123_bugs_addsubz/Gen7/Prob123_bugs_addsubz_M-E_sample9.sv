module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] add_result;
    wire [7:0] sub_result;

    // Compute addition and subtraction results
    assign add_result = a + b;
    assign sub_result = a - b;

    always @(*) begin
        // Select addition or subtraction based on do_sub
        out = do_sub ? sub_result : add_result;
        // Compute zero flag
        result_is_zero = ~|out;
    end

endmodule