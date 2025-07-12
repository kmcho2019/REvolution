module TopModule (
    input clk,
    input a,
    output reg q
);

reg a_prev;

always @(posedge clk) begin
    a_prev <= a;  // Store previous value of a
    
    if (~a_prev && a) begin  // Detect rising edge of a
        q <= ~q;  // Toggle output only on 0->1 transition
    end
    else if (!a_prev && !a) begin  // Initial condition
        q <= 1'b1;
    end
    // Otherwise q maintains its value
end

endmodule