module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    // Clock gating enable signal: active when counting or resetting
    wire enable = slowena | reset;

    // Gated clock signal
    reg gated_clk;
    reg clk_enable_ff;

    // Simple clock gating flip-flop to reduce glitches
    always @(posedge clk) begin
        clk_enable_ff <= enable;
        gated_clk <= clk & clk_enable_ff;
    end

    always @(posedge gated_clk) begin
        if (reset) begin
            q <= 4'd0;
        end else begin
            if (q == 4'd9)
                q <= 4'd0;
            else
                q <= q + 4'd1;
        end
    end

endmodule