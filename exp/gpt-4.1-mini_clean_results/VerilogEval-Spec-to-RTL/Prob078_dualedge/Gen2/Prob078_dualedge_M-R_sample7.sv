module TopModule (
    input  clk,
    input  d,
    output q
);

    reg q_pos, q_neg;

    // Positive edge triggered register
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge triggered register
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Output mux using continuous assignment based on clk level
    assign q = clk ? q_pos : q_neg;

endmodule