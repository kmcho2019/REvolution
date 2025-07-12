module TopModule (
    input clk,
    input d,
    output q
);

    reg q_pos;
    reg q_neg;
    reg inv_clk_d;

    // Create a delayed inverted clock signal synchronized to clk
    always @(posedge clk) begin
        inv_clk_d <= ~clk;
    end

    // Capture data on positive edge of clk
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Capture data on delayed inverted clock edge (also posedge clk domain)
    always @(posedge clk) begin
        if (inv_clk_d) 
            q_neg <= d;
    end

    // Output is selected based on current clk level
    assign q = clk ? q_pos : q_neg;

endmodule