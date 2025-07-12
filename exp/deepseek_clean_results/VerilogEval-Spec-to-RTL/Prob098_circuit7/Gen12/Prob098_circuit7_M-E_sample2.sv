module TopModule (
    input clk,
    input a,
    output reg q
);

reg prev_a;

always @(posedge clk) begin
    prev_a <= a;  // Store previous value of a
    
    // Toggle q only when a changes from 0 to 1
    if (!prev_a && a) begin
        q <= ~q;
    end
end

endmodule