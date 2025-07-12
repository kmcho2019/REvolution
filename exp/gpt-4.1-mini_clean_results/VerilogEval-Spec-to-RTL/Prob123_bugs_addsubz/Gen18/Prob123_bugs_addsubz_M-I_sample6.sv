module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_comp;       // Complemented b if do_sub=1, else b unchanged
    wire [8:0] sum_ext;      // Extended sum to capture carry out

    assign b_comp = b ^ {8{do_sub}};  // Invert b if do_sub=1
    assign sum_ext = a + b_comp + do_sub; // Add a and b_comp + carry_in

    always @(*) begin
        out = sum_ext[7:0];
        result_is_zero = ~|sum_ext[7:0];
    end

endmodule