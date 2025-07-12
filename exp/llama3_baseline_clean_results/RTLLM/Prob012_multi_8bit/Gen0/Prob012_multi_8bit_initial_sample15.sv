module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

always @(*)
begin
    product = 16'd0; // Initialize product to zero
    reg [7:0] temp_A; // Temporary register for A
    reg [2:0] i; // Loop counter
    
    temp_A = A; // Load A into temp_A
    
    for(i = 0; i < 8; i = i + 1)
    begin
        if(B[i] == 1'b1) // Check if current bit of B is set
        begin
            product = product + (temp_A << i); // Add shifted A to product
        end
        // No need for else, as product remains unchanged if bit is 0
    end
end

endmodule