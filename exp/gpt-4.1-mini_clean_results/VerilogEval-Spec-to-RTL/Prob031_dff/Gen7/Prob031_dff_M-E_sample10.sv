module TopModule (
    input clk,
    input d,
    output reg q
);

    reg intermediate;

    // First stage: capture input d into intermediate register
    always @(posedge clk) begin
        intermediate <= d;
    end

    // Second stage: transfer intermediate to output q
    always @(posedge clk) begin
        q <= intermediate;
    end

endmodule