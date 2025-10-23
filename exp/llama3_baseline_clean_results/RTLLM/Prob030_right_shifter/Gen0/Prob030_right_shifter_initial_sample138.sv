module right_shifter(
    input clk,  // Clock signal
    input d,   // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // Register to store the shifted value
reg [7:0] temp;  // Temporary register to store the shifted value

// Initialize the q register to 0
initial
begin
    q = 8'd0;
end

// Always block to perform the right shift operation on the rising edge of the clock
always @ (posedge clk)
begin
    // Right shift the contents of q by 1 bit
    temp = q >> 1;
    
    // Insert the new input bit d into the most significant position of temp
    temp[7] = d;
    
    // Assign the value of temp to q
    q <= temp;
end

endmodule