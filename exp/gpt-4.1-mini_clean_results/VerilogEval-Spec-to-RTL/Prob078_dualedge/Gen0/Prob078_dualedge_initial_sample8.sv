module TopModule(
    input clk,
    input d,
    output reg q
);

    reg q_pos, q_neg;

    // Capture d at rising edge
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Capture d at falling edge
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Output updates combinationally based on clk level
    always @(*) begin
        if (clk)
            q = q_pos;
        else
            q = q_neg;
    end

endmodule