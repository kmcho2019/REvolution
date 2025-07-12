module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_xor;

    assign b_xor = b ^ {8{do_sub}};

    always @(*) begin
        out = a + b_xor + do_sub;
        result_is_zero = ~|out;
    end

endmodule