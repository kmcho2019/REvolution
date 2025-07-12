module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

    // 8 D flip-flops to store the input data
    reg [7:0] q_reg;

    // Update the output on the positive edge of the clock
    always @(posedge clk) begin
        q_reg <= d;
    end

    // Continuously assign the output
    assign q = q_reg;

endmodule