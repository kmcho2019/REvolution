module TopModule(
    input clk,
    input a,
    output reg q
);

reg prev_a; // stores the value of a from the previous clock cycle

always @(posedge clk) begin
    prev_a <= a;
    if (prev_a == 1 && a == 1) begin
        q <= 0;
    end else if (prev_a == 0 && a == 0) begin
        q <= 1;
    end
end

endmodule