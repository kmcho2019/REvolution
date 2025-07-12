module TopModule (
    input clk,
    input d,
    output reg q
);

    reg q_pos;
    reg q_neg;

    // Positive edge flip-flop captures input d on rising edge
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Negative edge flip-flop captures input d on falling edge
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Output updates combinationally based on clk level:
    // When clk=1, output q_pos; else output q_neg
    always @(*) begin
        if (clk)
            q = q_pos;
        else
            q = q_neg;
    end

endmodule