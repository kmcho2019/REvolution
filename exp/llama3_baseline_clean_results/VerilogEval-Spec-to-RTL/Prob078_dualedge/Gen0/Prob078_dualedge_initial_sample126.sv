module TopModule(
    input  clk,
    input  d,
    output q
    );

    reg q_pos;  // Output of positive edge triggered flip-flop
    reg q_neg;  // Output of negative edge triggered flip-flop

    always @(posedge clk) begin
        q_pos <= d;
    end

    always @(negedge clk) begin
        q_neg <= d;
    end

    assign q = (clk == 1'b1) ? q_pos : q_neg;

endmodule