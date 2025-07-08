module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);

    reg q_pos;
    reg q_neg;

    // Sample input on positive edge
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Sample input on negative edge
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Output mux selects q_pos or q_neg depending on clk level
    assign q = clk ? q_pos : q_neg;

endmodule