module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    // Internal 64-bit accumulator to hold full precision sum of products
    reg [63:0] acc;

    // Asynchronous reset and synchronous accumulate multiply result
    always @(posedge clk or posedge rst) begin
        if (rst)
            acc <= 64'b0;
        else
            acc <= acc + (a * b);
    end

    // Output the lower 32 bits of the accumulator as the current accumulated sum
    always @(posedge clk or posedge rst) begin
        if (rst)
            c <= 32'b0;
        else
            c <= acc[31:0];
    end

endmodule