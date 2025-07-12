module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

initial q = 3'b100; // Initialize q to 4 (binary 100)

always @(posedge clk) begin
    if (!a) begin
        if (q == 3'b111) // If q is 7 (binary 111), reset to 0
            q <= 3'b000;
        else
            q <= q + 1'b1; // Increment q by 1
    end
end

endmodule