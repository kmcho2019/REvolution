module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

initial q = 8'b0;

always @(posedge clk) begin
    // Shift right by one bit and insert new bit d at MSB in a single operation
    q <= {d, q[7:1]};
end

endmodule