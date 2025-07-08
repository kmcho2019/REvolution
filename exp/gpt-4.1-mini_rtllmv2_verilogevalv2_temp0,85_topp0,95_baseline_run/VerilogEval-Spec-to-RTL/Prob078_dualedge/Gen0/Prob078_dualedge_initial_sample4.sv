module TopModule (
    input  clk,
    input  d,
    output reg q
);

    reg pos_ff;
    reg neg_ff;

    // Positive edge flip-flop
    always @(posedge clk) begin
        pos_ff <= d;
    end

    // Negative edge flip-flop
    always @(negedge clk) begin
        neg_ff <= d;
    end

    // Output multiplexing based on clk level
    always @(*) begin
        if (clk)
            q = pos_ff;
        else
            q = neg_ff;
    end

endmodule