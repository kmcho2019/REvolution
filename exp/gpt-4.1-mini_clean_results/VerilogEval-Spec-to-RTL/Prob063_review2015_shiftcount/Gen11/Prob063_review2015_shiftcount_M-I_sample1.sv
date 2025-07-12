module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    wire clk_en = shift_ena | count_ena;
    reg gated_clk;

    // Simple clock gating flip-flop for positive-edge triggered register
    // Note: In practical ASIC flows, use dedicated clock gating cells.
    always @(posedge clk) begin
        gated_clk <= clk_en;
    end

    always @(posedge clk) begin
        if (gated_clk) begin
            if (shift_ena)
                q <= {q[2:0], data};
            else if (count_ena)
                q <= q - 1;
        end
    end

endmodule