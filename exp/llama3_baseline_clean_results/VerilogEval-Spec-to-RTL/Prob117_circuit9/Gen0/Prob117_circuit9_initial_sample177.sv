module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

initial q = 3'b000;

always @(posedge clk) begin
    if (a) begin
        if (q == 3'b000) q <= 3'b100; // Set initial value to 4 on the first rising edge of 'clk'
        else q <= q; // Hold the value when 'a' is high
    end
    else begin
        q <= q + 1; // Increment when 'a' is low
    end
end

endmodule