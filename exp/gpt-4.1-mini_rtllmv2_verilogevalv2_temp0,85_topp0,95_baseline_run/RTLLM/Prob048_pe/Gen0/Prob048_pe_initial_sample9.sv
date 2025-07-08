module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    // Use a wider register to hold the intermediate accumulation result to prevent overflow
    reg [63:0] acc;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            acc <= 64'b0;
            c <= 32'b0;
        end else begin
            // Multiply a and b (both 32-bit unsigned), add to accumulator
            acc <= acc + (a * b);
            c <= acc[31:0]; // Output the lower 32 bits of the accumulator
        end
    end

endmodule