module TopModule (
    input clk,
    input a,
    output reg q
);

reg a_prev;

always @(posedge clk) begin
    a_prev <= a;
    
    if (~a_prev && a) begin  // Detect rising edge of a
        q <= ~q;            // Toggle q
    end
end

endmodule