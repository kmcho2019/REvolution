module pe (
    input  logic clk,  // Clock signal
    input  logic rst,  // Reset signal
    input  logic [31:0] a,  // Input operand A
    input  logic [31:0] b,  // Input operand B
    output logic [31:0] c  // Accumulated result
);

// Internal signals
logic [31:0] mult_result;
logic [31:0] c_reg;

// Combinational multiplication
assign mult_result = a * b;

// Sequential accumulation
always_ff @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + mult_result;
    end
end

// Output assignment
assign c = c_reg;

endmodule