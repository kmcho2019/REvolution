module TopModule(
    input clk,
    input a,
    output reg q
);

// Initialize q to 1 when a is 0 at the start
initial q = 1;

always @(posedge clk) begin
    // If a is 1 at the rising edge of clk, toggle q
    if (a == 1) begin
        q = ~q; // Toggle q
    end else begin
        // If a is 0, keep q the same
        q = q;
    end
end

endmodule