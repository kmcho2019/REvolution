module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);

    reg q_pos;
    reg q_neg;

    // Sample input d on positive edge of clk
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Sample input d on negative edge of clk
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Output is selected based on current clk level
    assign q = clk ? q_pos : q_neg;

endmodule