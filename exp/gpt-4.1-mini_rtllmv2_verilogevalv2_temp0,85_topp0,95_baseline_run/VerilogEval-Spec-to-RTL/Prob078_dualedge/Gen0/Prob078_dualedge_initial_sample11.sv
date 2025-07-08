module TopModule (
    input  clk,
    input  d,
    output reg q
);

    reg q_posedge;
    reg q_negedge;

    // Flip-flop triggered on positive edge
    always @(posedge clk) begin
        q_posedge <= d;
    end

    // Flip-flop triggered on negative edge
    always @(negedge clk) begin
        q_negedge <= d;
    end

    // Mux output based on clk
    always @(*) begin
        if (clk)
            q = q_posedge;
        else
            q = q_negedge;
    end

endmodule