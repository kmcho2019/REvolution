module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Water level states
    wire above_s2  = s[2];               // Water above highest sensor
    wire s2_to_s1  = ~s[2] & s[1];      // Between s[2] and s[1]
    wire s1_to_s0  = ~s[1] & s[0];      // Between s[1] and s[0]
    wire below_s0  = ~s[0];             // Below lowest sensor

    reg [1:0] prev_level;  // Track previous level for transition detection

    // Output assignments (direct from truth table)
    assign fr0 = reset ? 1'b1 : ~above_s2;
    assign fr1 = reset ? 1'b1 : (s1_to_s0 | below_s0);
    assign fr2 = reset ? 1'b1 : below_s0;
    
    // DFR is 1 if: water is rising AND not at highest level OR during reset
    assign dfr = reset ? 1'b1 : 
                (({above_s2, s2_to_s1, s1_to_s0, below_s0} > {prev_level}) && 
                 ~above_s2);

    // Update previous level on clock edge
    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'b00;  // Represents below_s0 state
        end else begin
            // Encode current level (priority encoded)
            prev_level <= above_s2 ? 2'b11 :
                         s2_to_s1 ? 2'b10 :
                         s1_to_s0 ? 2'b01 :
                         2'b00;  // below_s0
        end
    end

endmodule