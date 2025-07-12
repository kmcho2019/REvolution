module TopModule (
    input clk,
    input d,
    output q
);

    reg q_posedge;
    reg q_negedge;

    always @(posedge clk) begin
        q_posedge <= d;
    end

    always @(negedge clk) begin
        q_negedge <= d;
    end

    // When clk is high, output the posedge flip-flop output,
    // when clk is low, output the negedge flip-flop output.
    assign q = clk ? q_posedge : q_negedge;

endmodule