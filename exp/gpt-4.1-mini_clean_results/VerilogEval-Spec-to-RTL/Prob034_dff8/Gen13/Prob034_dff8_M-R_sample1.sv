module TopModule (
    input        clk,
    input  [7:0] d,
    output [7:0] q
);

    reg [7:0] q_reg;

    // Sequential logic: 8 D flip-flops triggered on posedge clk
    always @(posedge clk) begin
        q_reg <= d;
    end

    // Continuous assignment from register to output port
    assign q = q_reg;

endmodule