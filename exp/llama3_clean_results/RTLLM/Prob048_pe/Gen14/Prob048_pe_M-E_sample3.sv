module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Bit-Serial Multiplier
wire [31:0] mult_result;
reg [4:0] counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 5'd0;
    end else if (counter == 5'd31) begin
        counter <= 5'd0;
    end else begin
        counter <= counter + 5'd1;
    end
end

assign mult_result = (a[31-counter]? (b << counter) : 32'd0);

// Parallel Accumulator
reg [31:0] c_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + mult_result;
    end
end

// Output Assignment
assign c = c_reg;

endmodule