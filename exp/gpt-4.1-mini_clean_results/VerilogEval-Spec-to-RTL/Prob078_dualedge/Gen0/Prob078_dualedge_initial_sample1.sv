module TopModule (
    input clk,
    input d,
    output reg q
);

    reg q_pos;
    reg q_neg;

    // Capture data on positive edge
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Capture data on negative edge
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Output mux selects the correct sampled data based on clock level
    always @(*) begin
        if (clk)
            q = q_pos;
        else
            q = q_neg;
    end

endmodule