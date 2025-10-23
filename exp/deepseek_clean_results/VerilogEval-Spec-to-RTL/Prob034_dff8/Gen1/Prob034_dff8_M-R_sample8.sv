module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

    // Array of registers for the flip-flops
    reg [7:0] q_reg;

    // Assign outputs
    assign q = q_reg;

    // Single always block for all 8 flip-flops
    always @(posedge clk) begin
        q_reg <= d;
    end

endmodule