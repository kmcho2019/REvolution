module TopModule (
    input  clk,
    input  d,
    output reg q
);

    reg q_posedge;
    reg q_negedge;

    // Capture input at rising edge
    always @(posedge clk) begin
        q_posedge <= d;
    end

    // Capture input at falling edge
    always @(negedge clk) begin
        q_negedge <= d;
    end

    // Output follows q_posedge when clk is high, q_negedge when clk is low
    always @(*) begin
        if (clk)
            q = q_posedge;
        else
            q = q_negedge;
    end

endmodule