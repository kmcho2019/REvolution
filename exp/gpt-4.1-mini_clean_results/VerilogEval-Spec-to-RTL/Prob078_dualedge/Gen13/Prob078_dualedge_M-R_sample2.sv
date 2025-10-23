module TopModule (
    input  clk,
    input  d,
    output q
);

    reg q_pos;
    reg q_neg;

    // Positive edge triggered register
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge triggered register
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Output mux based on current clock level
    assign q = clk ? q_pos : q_neg;

endmodule