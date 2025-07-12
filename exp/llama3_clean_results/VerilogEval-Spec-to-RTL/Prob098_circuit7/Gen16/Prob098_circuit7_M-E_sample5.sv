module TopModule(
    input clk,
    input a,
    output reg q
);

// Initialize output q to 1
initial q = 1'b1;

// Toggle output q when a is 1 at the positive edge of the clock
always @(posedge clk) begin
    if (a) begin
        q <= ~q;
    end
end

endmodule