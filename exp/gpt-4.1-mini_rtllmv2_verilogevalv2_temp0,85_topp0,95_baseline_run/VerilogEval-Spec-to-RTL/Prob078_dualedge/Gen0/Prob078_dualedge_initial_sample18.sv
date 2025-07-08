module TopModule (
    input  clk,
    input  d,
    output reg q
);

    reg d_pos, d_neg;

    // Positive edge triggered flip-flop stores d on posedge clk
    always @(posedge clk) begin
        d_pos <= d;
    end

    // Negative edge triggered flip-flop stores d on negedge clk
    always @(negedge clk) begin
        d_neg <= d;
    end

    // Output q selects the correct data depending on clk state
    always @(*) begin
        if (clk)
            q = d_pos;
        else
            q = d_neg;
    end

endmodule