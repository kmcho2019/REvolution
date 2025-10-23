module TopModule (
    input wire clk,
    input wire d,
    output wire q
);

    reg d_posedge_q;
    reg d_negedge_q;
    reg clk_d;  // delayed clock to detect edges

    // Sample delayed clock to detect negative edge
    always @(posedge clk) begin
        clk_d <= clk;
    end

    // Positive edge FF: sample d on clk posedge
    always @(posedge clk) begin
        d_posedge_q <= d;
    end

    // "Negative edge" FF: sample d on clk posedge only when previous clk was high (i.e., falling edge just occurred)
    always @(posedge clk) begin
        if (clk_d) begin
            d_negedge_q <= d;
        end
    end

    // Output mux: select posedge or negedge sample based on clock level
    assign q = clk ? d_posedge_q : d_negedge_q;

endmodule