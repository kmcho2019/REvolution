module right_shifter(
    input clk,
    input d,
    output [7:0] q
);

reg [7:0] q;

initial
    q = 8'b0;

always @(posedge clk) begin
    reg [7:0] temp_q;
    temp_q = q >> 1; // Shift q to the right by one bit
    temp_q[7] = d;   // Insert the new input bit into the most significant position
    q <= temp_q;     // Assign the temporary value back to q
end

endmodule