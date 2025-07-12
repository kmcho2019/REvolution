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

    // Track previous sensor readings for level change detection
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
        end
    end

    // Detect rising water level (any sensor newly asserted)
    assign level_rising = ((s[0] & ~prev_s[0]) | 
                         (s[1] & ~prev_s[1]) | 
                         (s[2] & ~prev_s[2]));

    // Output logic - direct mapping from sensor inputs
    assign fr0 = reset ? 1'b1 : ~(s[2] & s[1] & s[0]);
    assign fr1 = reset ? 1'b1 : ~(s[1] | (s[2] & s[1]));
    assign fr2 = reset ? 1'b1 : ~(s[0] | s[1] | s[2]);
    assign dfr = reset ? 1'b1 : (level_rising & ~(s[2] & s[1] & s[0]));

endmodule