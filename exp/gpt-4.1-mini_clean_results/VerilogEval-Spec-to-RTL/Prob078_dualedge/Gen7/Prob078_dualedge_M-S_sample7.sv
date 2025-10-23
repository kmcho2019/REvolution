module TopModule (
    input  clk,
    input  d,
    output q
);

    reg q_pos, q_neg;

    // Capture input on positive clock edge
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Capture input on negative clock edge using inverted clock
    always @(posedge ~clk) begin
        q_neg <= d;
    end

    // Mux output based on clock level
    assign q = clk ? q_pos : q_neg;

endmodule