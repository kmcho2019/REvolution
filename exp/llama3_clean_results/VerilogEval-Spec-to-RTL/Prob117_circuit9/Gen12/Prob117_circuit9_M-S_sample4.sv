module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

initial q = 3'b100;

always @(posedge clk) begin
    if (a) 
        q <= 3'b100; // Reset to 4 when 'a' is high
    else if (q == 3'b110) 
        q <= 3'b000; // Wrap around to 0 when q reaches 6 and 'a' is low
    else 
        q <= q + 1'b1; // Increment 'q' when 'a' is low and q is not 6
end

endmodule