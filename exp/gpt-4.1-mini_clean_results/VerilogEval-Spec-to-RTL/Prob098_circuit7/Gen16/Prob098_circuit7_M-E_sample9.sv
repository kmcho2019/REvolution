module TopModule (
    input clk,
    input a,
    output q
);
    reg a_d;

    // On rising edge of clk, sample input a
    always @(posedge clk) begin
        a_d <= a;
    end

    // Output is the inverse of the registered value of a
    assign q = ~a_d;
endmodule