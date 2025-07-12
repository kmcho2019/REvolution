module right_shifter(
    input clk,
    input d,
    output reg [7:0] q
);

initial q = 8'b0;

always @(posedge clk) begin
    q[7] = d;  // Assign the new input bit to the most significant position
    q = {q[7], q[7:1]};  // Right shift q by 1 bit and insert the new input bit at MSB
end

endmodule