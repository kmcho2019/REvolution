module TopModule (
    input             clk,
    input             do_sub,
    input      [7:0]  a,
    input      [7:0]  b,
    output reg [7:0]  out,
    output reg        result_is_zero
);

    wire [7:0] b_xor;     // Conditionally inverted b
    wire [8:0] sum;       // 9-bit sum including carry out

    assign b_xor = b ^ {8{do_sub}};               // invert b if do_sub=1
    assign sum = {1'b0, a} + {1'b0, b_xor} + do_sub; // add a + b_xor + carry_in

    // Register outputs on clock to reduce glitches and improve timing/power
    always @(posedge clk) begin
        out <= sum[7:0];
        result_is_zero <= ~|sum[7:0];             // zero flag from registered output
    end

endmodule