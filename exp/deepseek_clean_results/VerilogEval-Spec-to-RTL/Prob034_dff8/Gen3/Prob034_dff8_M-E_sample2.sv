module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

    // Implement as a parallel-load shift register
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        shift_reg <= d;  // Parallel load operation
    end

    assign q = shift_reg;

endmodule