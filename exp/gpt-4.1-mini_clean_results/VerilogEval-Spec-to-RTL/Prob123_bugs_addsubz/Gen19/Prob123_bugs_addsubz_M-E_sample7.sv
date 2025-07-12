module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    reg signed [8:0] result;  // 9 bits to hold possible overflow

    always @(*) begin
        // Compute sum or difference based on do_sub
        if (do_sub)
            result = $signed({1'b0, a}) - $signed({1'b0, b});
        else
            result = $signed({1'b0, a}) + $signed({1'b0, b});

        // Assign output as lower 8 bits (ignore overflow)
        out = result[7:0];

        // Zero flag set if output is zero
        result_is_zero = (out == 8'd0);
    end

endmodule