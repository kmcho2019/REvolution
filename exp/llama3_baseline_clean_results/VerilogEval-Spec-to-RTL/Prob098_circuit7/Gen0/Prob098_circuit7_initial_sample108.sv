module TopModule(
    input clk,
    input a,
    output reg q
);

reg first_zero = 0;

always @(posedge clk) begin
    if (!first_zero && !a) begin
        first_zero <= 1;
        q <= 1;
    end
    else if (a) begin
        q <= ~q;
    end
end

endmodule