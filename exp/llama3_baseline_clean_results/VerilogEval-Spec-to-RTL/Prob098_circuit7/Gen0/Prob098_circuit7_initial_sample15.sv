module TopModule(
    input clk,
    input a,
    output reg q
);

// Initial condition based on the first rising edge when a is 0
initial q = 1'b1;

always @(posedge clk) begin
    if (a) begin
        // Toggle q when a is 1 at the rising edge of the clock
        q <= ~q;
    end else begin
        // Do not change q when a is 0
        q <= q;
    end
end

endmodule