module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    reg [7:0] b_comp;

    always @(*) begin
        if (do_sub)
            b_comp = ~b;       // Prepare two's complement inversion for subtraction
        else
            b_comp = b;
    end

    always @(*) begin
        // Perform addition or subtraction:
        // if do_sub=1: a + (~b) + 1 = a - b
        // else: a + b
        out <= a + b_comp + do_sub;
    end

    always @(*) begin
        // Explicit zero detection by comparing out to zero:
        if (out == 8'b0)
            result_is_zero <= 1'b1;
        else
            result_is_zero <= 1'b0;
    end

endmodule