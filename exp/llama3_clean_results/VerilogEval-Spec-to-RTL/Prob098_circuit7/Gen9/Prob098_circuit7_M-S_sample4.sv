module TopModule(
    input clk,
    input a,
    output reg q
);

// Initialize q to 1
initial q = 1'b1;

// Update q at the positive edge of the clock
always @(posedge clk) begin
    if (a) begin
        q <= 1'b0;
    end else if (q == 1'b0) begin
        q <= 1'b1;
    end
end

endmodule