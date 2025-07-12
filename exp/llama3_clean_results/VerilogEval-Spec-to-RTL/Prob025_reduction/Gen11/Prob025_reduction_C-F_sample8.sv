// Module to calculate the even parity bit for an 8-bit input byte using XOR reduction operator and parallel counter
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Calculate the parity bit using XOR reduction operator
assign parity = ^in;

// Initialize the count to 0
reg [3:0] count;

// Use a series of half-adders and full-adders to count the number of 1's in the input byte (for educational purposes)
always @(*) begin
    count = 0;
    for (int i = 0; i < 8; i++) begin
        if (in[i] == 1) begin
            count = count + 1;
        end
    end
end

// The count can be used for educational purposes to demonstrate the alternative method
// However, it is not used in the actual parity calculation

endmodule