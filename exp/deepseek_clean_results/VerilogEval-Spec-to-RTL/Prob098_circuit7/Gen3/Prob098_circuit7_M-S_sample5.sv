module TopModule (
    input clk,
    input a,
    output reg q
);

reg a_prev;

always @(posedge clk) begin
    a_prev <= a;
    if (~a_prev & a) begin  // rising edge detection
        q <= ~q;
    end
end

endmodule