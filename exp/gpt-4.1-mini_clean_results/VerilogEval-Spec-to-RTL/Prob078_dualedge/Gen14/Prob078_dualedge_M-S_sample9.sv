module TopModule (
    input clk,
    input d,
    output reg q
);

    reg q_pos, q_neg;

    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Positive edge triggered flip-flop on inverted clk (equivalent to negedge clk)
    always @(posedge ~clk) begin
        q_neg <= d;
    end

    // Output mux selecting which FF output to use based on clk level
    always @(*) begin
        if (clk)
            q = q_pos;
        else
            q = q_neg;
    end

endmodule