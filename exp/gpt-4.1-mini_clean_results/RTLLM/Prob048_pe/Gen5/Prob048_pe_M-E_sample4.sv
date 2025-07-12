module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    // 64-bit register to hold accumulated result
    reg [63:0] acc;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            acc = 64'b0;  // Asynchronous reset using blocking assignment
        end else begin
            acc <= acc + a * b; // Non-blocking accumulation on clock edge
        end
    end

    // Output upper 32 bits of accumulator
    assign c = acc[63:32];

endmodule