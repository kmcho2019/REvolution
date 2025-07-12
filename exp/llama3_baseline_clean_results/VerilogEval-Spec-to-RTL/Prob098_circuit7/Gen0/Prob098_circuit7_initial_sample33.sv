module TopModule(
    input clk,
    input a,
    output reg q
);

reg prev_a; // To hold the previous state of 'a'

always @(posedge clk) begin
    // Update the previous state of 'a'
    prev_a <= a;
    
    // If 'a' is the same for two consecutive cycles, toggle 'q'
    if (a == prev_a) begin
        q <= ~q; // Toggle 'q'
    end
end

endmodule