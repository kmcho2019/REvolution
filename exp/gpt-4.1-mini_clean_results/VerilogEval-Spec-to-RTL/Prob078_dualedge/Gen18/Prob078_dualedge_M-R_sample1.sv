module TopModule (
    input clk,
    input d,
    output reg q
);
    reg q_pos, q_neg;

    // Capture input d on rising edge of clk
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Capture input d on falling edge of clk
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Update output q combinationally based on clk level
    always @(*) begin
        if (clk)
            q = q_pos;
        else
            q = q_neg;
    end
endmodule