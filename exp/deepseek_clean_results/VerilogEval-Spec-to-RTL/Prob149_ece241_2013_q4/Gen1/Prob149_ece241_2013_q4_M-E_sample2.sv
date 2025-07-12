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
    reg was_lower;

    // History and rising detection
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
            was_lower <= 1'b1;
        end else begin
            prev_s <= s;
            // Detect if previous level was lower than current
            was_lower <= (s > prev_s);
        end
    end

    // Output logic - implemented as parallel priority cases
    assign fr0 = ~(&s);  // Any sensor off
    assign fr1 = (s < 3'b011);  // Below s[1]
    assign fr2 = (s == 3'b000); // Below s[0]
    
    // Supplemental flow when:
    // 1. Currently between sensors AND
    // 2. Level was previously lower AND
    // 3. Not at maximum flow already
    assign dfr = was_lower && 
                ((s == 3'b011) || (s == 3'b001)) && 
                ~(s == 3'b000);

endmodule