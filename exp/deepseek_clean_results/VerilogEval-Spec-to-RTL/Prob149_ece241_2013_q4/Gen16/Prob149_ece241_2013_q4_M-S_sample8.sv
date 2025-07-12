module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    reg [2:0] prev_s;

    // Track previous sensor values
    always @(posedge clk) begin
        if (reset)
            prev_s <= 3'b000;
        else
            prev_s <= s;
    end

    // Nominal flow outputs (active high)
    assign fr0 = reset ? 1'b1 : ~s[2];
    assign fr1 = reset ? 1'b1 : ~(s[2] | s[1]);
    assign fr2 = reset ? 1'b1 : ~(s[2] | s[1] | s[0]);

    // Supplemental flow (active when water level is rising)
    assign dfr = reset ? 1'b1 : (s > prev_s);

endmodule