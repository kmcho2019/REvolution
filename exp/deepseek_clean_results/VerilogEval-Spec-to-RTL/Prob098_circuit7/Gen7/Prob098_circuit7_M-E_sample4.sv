module TopModule (
    input clk,
    input a,
    output reg q
);

reg a_prev;

always @(posedge clk) begin
    a_prev <= a;
    if (~a_prev & a) begin  // Detect rising edge of a
        q <= 0;
    end
    else if (q == 1'b1) begin  // Maintain initial state
        q <= 1;
    end
end

initial begin
    q = 1;  // Initial state
    a_prev = 0;
end

endmodule