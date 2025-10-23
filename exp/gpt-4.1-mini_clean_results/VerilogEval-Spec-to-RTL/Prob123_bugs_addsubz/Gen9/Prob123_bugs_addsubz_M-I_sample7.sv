module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_xor; // Conditionally inverted b

    assign b_xor = b ^ {8{do_sub}};  // Invert b bits if do_sub=1

    always @(*) begin
        out = a + b_xor + do_sub;           // Perform add or subtract
        result_is_zero = ~|out;              // Zero flag: 1 if out == 0, else 0
    end

endmodule