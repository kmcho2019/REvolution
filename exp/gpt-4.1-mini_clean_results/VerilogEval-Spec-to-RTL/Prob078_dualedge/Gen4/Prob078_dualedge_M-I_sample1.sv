module TopModule (
    input clk,
    input d,
    output reg q
);
    reg q_pos, q_neg;
    reg toggle;

    always @(posedge clk) begin
        q_pos <= d;
    end

    always @(negedge clk) begin
        q_neg <= d;
    end

    // Toggle signal to select between posedge and negedge samples on each posedge clk
    always @(posedge clk) begin
        toggle <= ~toggle;
    end

    always @(posedge clk) begin
        q <= toggle ? q_neg : q_pos;
    end
endmodule