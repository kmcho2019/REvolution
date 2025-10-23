module right_shifter(
    input clk, 
    input d, 
    output [7:0] q
);

reg [7:0] q;

initial
    q = 8'b0;

always @(posedge clk)
begin
    reg [7:0] temp;
    temp = q >> 1; // Right shift the register
    temp[7] = d; // Insert the new input bit into the most significant position
    q <= temp; // Assign the new value to q
end

endmodule