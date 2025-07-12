// Module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

reg [2:0] count;  // Counter to track the number of 1s in the input byte
reg [7:0] temp;   // Temporary register to hold the input byte

always @(in) begin
    count = 0;  // Reset the counter
    temp = in;  // Assign the input byte to the temporary register
    
    // Iterate through each bit of the input byte
    for (int i = 0; i < 8; i++) begin
        if (temp[i] == 1'b1) begin  // Check if the current bit is 1
            count = count + 1;  // Increment the counter if the bit is 1
        end
    end
    
    // Determine the parity bit based on the count
    if (count % 2 == 0) begin  // If the count is even
        parity = 1'b0;  // Parity bit is 0
    end else begin  // If the count is odd
        parity = 1'b1;  // Parity bit is 1
    end
end

endmodule