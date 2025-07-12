module right_shifter(
    input clk,
    input d,
    output [7:0] q
    );

reg [7:0] q;

always @(posedge clk) begin
    q[7] <= d; // assign d to the most significant bit
    q <= {q[7], q[7:1]}; // right shift q by 1 bit
end

endmodule