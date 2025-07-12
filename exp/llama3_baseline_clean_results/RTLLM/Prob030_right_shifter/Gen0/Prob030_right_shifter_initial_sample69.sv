module right_shifter(
    input clk,
    input d,
    output [7:0] q
);

reg [7:0] q;

initial
begin
    q = 8'b0;
end

always @(posedge clk)
begin
    q = (q >> 1); // Right shift the current state
    q[7] = d;    // Insert the new input bit into the most significant position
end

endmodule