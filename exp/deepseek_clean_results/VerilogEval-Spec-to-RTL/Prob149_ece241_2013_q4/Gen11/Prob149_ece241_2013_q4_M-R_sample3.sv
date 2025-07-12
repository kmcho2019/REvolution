module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Track previous water level state
    reg [2:0] prev_level;
    reg was_rising;

    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 3'b000;
            was_rising <= 1'b0;
        end else begin
            prev_level <= s;
            // Detect if water level was rising (current > previous)
            was_rising <= (s > prev_level);
        end
    end

    // Output assignments with reset handling
    assign fr0 = reset ? 1'b1 : (s != 3'b111);
    assign fr1 = reset ? 1'b1 : (s[1:0] != 2'b11);
    assign fr2 = reset ? 1'b1 : (s == 3'b000);
    
    // Supplemental flow when:
    // 1. Currently rising (s > prev_level), or
    // 2. Was rising last cycle and not at max level
    assign dfr = reset ? 1'b1 : ((s > prev_level) || (was_rising && (s != 3'b111)));

endmodule