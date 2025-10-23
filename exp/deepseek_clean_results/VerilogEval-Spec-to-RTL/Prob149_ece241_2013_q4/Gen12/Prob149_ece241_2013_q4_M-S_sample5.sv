module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    reg prev_s0;  // Only track previous state of lowest sensor

    always @(posedge clk) begin
        if (reset) begin
            prev_s0 <= 1'b0;
        end else begin
            prev_s0 <= s[0];
        end
    end

    // Nominal flow outputs
    assign fr0 = reset ? 1'b1 : ~s[0];
    assign fr1 = reset ? 1'b1 : ~(s[0] | s[1]);
    assign fr2 = reset ? 1'b1 : ~(s[0] | s[1] | s[2]);

    // Supplemental flow (water rising)
    assign dfr = reset ? 1'b1 : (s[0] & ~prev_s0);

endmodule