module TopModule (
    input clk,
    input d,
    output q
);

    parameter HOLD_THRESHOLD = 2;  // Number of cycles to hold before gating
    
    // Storage elements for both clock edges
    reg q_pos;  // Positive edge triggered
    reg q_neg;  // Negative edge triggered
    
    // Data stability detection
    reg [1:0] d_history;
    wire data_stable = (d_history[0] == d_history[1]) && (d_history[0] == d);
    wire enable = !data_stable;
    
    // Capture data on positive clock edge when enabled
    always @(posedge clk) begin
        q_pos <= enable ? d : q_pos;
        d_history <= {d_history[0], d};
    end
    
    // Capture data on negative clock edge when enabled
    always @(negedge clk) begin
        q_neg <= enable ? d : q_neg;
    end
    
    // Efficient clock-phase-based output selection
    assign q = clk ? q_pos : q_neg;

endmodule