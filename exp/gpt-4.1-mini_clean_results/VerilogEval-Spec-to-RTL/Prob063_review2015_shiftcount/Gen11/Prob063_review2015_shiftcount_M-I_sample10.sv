module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    wire enable = shift_ena | count_ena;
    reg gated_clk;

    // Simple clock gating by ANDing clk with enable.
    // For real designs, consider dedicated clock gating cells.
    always @(posedge clk) begin
        gated_clk <= enable;
    end

    always @(posedge clk) begin
        if (enable) begin
            if (shift_ena)
                q <= {q[2:0], data};
            else if (count_ena)
                q <= q - 1;
        end
    end

endmodule