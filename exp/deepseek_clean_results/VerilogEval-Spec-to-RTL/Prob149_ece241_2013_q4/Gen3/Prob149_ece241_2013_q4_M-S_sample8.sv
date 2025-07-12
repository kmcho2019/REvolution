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
    wire level_rising;

    // Store previous sensor values for edge detection
    always @(posedge clk) begin
        if (reset) prev_s <= 3'b0;
        else prev_s <= s;
    end

    // Detect if water level is rising (any sensor newly active)
    assign level_rising = (s[0] & ~prev_s[0]) || 
                         (s[1] & ~prev_s[1]) || 
                         (s[2] & ~prev_s[2]);

    // Output logic - direct mapping from sensor inputs
    assign fr0 = reset ? 1'b1 : (s[2] ? 1'b0 : (s[1] ? 1'b1 : 1'b1));
    assign fr1 = reset ? 1'b1 : (s[2] ? 1'b0 : (s[1] ? 1'b0 : 1'b1));
    assign fr2 = reset ? 1'b1 : (s[0] ? 1'b0 : 1'b1);
    assign dfr = reset ? 1'b1 : (level_rising & ~s[2]);

endmodule