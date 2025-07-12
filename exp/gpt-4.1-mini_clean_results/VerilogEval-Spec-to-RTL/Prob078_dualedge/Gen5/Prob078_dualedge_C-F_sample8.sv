module TopModule (
    input clk,
    input d,
    output q
);
    reg q_posedge, q_negedge;

    // Positive edge-triggered register
    always @(posedge clk) begin
        q_posedge <= d;
    end

    // Negative edge-triggered register
    always @(negedge clk) begin
        q_negedge <= d;
    end

    // Continuous assignment mux output based on clock level
    assign q = clk ? q_posedge : q_negedge;

endmodule