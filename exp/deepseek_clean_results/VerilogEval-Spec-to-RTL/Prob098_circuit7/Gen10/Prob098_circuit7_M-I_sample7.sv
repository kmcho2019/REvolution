module TopModule (
    input clk,
    input a,
    output reg q
);

reg prev_a;

always @(posedge clk) begin
    prev_a <= a;
    if (~prev_a & a) begin  // rising edge of a
        q <= 0;
    end
    else if (prev_a & ~a) begin  // falling edge of a
        q <= 1;
    end
end

endmodule