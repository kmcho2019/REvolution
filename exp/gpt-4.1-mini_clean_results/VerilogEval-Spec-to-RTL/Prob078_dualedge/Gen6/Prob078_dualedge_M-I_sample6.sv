module TopModule (
    input  clk,
    input  d,
    output q
);

    reg clk_d;       // delayed clock to detect edges
    wire pos_edge, neg_edge;

    // Delay one clock cycle to detect edges
    always @(posedge clk) begin
        clk_d <= clk;
    end

    // Edge detection signals
    assign pos_edge =  clk & ~clk_d; // rising edge when clk changes 0->1
    assign neg_edge = ~clk &  clk_d; // falling edge when clk changes 1->0

    reg q_pos, q_neg;

    // Positive edge triggered FF with clock enable
    always @(posedge clk) begin
        if (pos_edge) begin
            q_pos <= d;
        end
    end

    // Negative edge triggered FF with clock enable
    always @(negedge clk) begin
        if (neg_edge) begin
            q_neg <= d;
        end
    end

    // Output mux based on clock level
    assign q = clk ? q_pos : q_neg;

endmodule