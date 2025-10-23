// Module to calculate the even parity bit for an 8-bit input byte using a counter
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

reg [2:0] count;  // 3-bit counter to count the number of 1's

always @(*) begin
    count = 3'b0;  // Initialize the counter to 0
    // Iterate through each bit of the input byte and count the number of 1's
    for (int i = 0; i < 8; i++) begin
        if (in[i] == 1'b1) begin
            count = count + 1'b1;  // Increment the counter for each 1 encountered
        end
    end
    // Determine the parity bit based on whether the count is even or odd
    if (count[0] == 1'b0) begin
        parity = 1'b0;  // Parity bit is 0 if the count is even
    end else begin
        parity = 1'b1;  // Parity bit is 1 if the count is odd
    end
end

endmodule