module TopModule (
    input clk,
    input d,
    output q
);

    wire pos_edge = (clk === 1'b1) && ($past(clk) === 1'b0);  // posedge detection
    wire neg_edge = (clk === 1'b0) && ($past(clk) === 1'b1);  // negedge detection

    reg pos_data, neg_data;

    // Positive edge capture
    assign pos_data = pos_edge ? d : pos_data;

    // Negative edge capture
    assign neg_data = neg_edge ? d : neg_data;

    // Output selection
    assign q = clk ? pos_data : neg_data;

endmodule