module pe (
    input clk, 
    input rst, 
    input [31:0] a, 
    input [31:0] b, 
    output reg [31:0] c
);

reg [31:0] product; // Register to store the intermediate product
reg [31:0] temp_c;  // Temporary register to store the accumulated result

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c <= 32'd0; // Reset the accumulator register to 0 on reset
        product <= 32'd0; // Reset the product register to 0 on reset
        temp_c <= 32'd0; // Reset the temporary accumulator register to 0 on reset
    end else begin
        product <= a * b; // Calculate the product of a and b in the first stage
        temp_c <= c + product; // Accumulate the product into the temporary register in the second stage
        c <= temp_c; // Update the accumulator register with the temporary result in the third stage
    end
end

endmodule