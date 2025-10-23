module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    always @(*) begin
        // Adder/subtractor selection
        case (do_sub)
          0: out = a + b;
          1: out = a - b;
        endcase

        // Zero flag assignment - clear and complete
        result_is_zero = (out == 8'b0);
    end

endmodule