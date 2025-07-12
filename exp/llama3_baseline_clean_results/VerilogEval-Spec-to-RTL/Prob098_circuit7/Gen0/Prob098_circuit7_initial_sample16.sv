module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a == 1) begin
        q <= ~q; // Invert q when a is 1
    end
end

initial begin
    q = 1; // Initialize q to 1
end

endmodule