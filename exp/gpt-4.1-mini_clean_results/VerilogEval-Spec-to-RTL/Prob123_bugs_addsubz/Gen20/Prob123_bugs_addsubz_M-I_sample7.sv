module TopModule (
    input  wire       do_sub,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output reg  [7:0] out,
    output reg        result_is_zero
);

    wire [8:0] sum_ext;

    // Compute addition or subtraction using Verilog "+" operator with conditional inversion
    // sum_ext includes carry-out bit to avoid truncation artifacts (though unused here)
    assign sum_ext = do_sub ? ( {1'b0, a} - {1'b0, b} ) : ( {1'b0, a} + {1'b0, b} );

    always @(*) begin
        out = sum_ext[7:0];
        result_is_zero = ~|sum_ext[7:0];
    end

endmodule