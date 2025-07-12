module TopModule (
    output one
);
    // Create a 3-stage ring oscillator
    wire osc_out;
    reg [2:0] osc_stages = 3'b000;
    
    always @(*) begin
        osc_stages[0] <= ~osc_stages[2];
        osc_stages[1] <= osc_stages[0];
        osc_stages[2] <= osc_stages[1];
    end
    
    assign osc_out = osc_stages[2];
    
    // Sample the oscillator with itself to force metastability
    reg metastable_reg = 1'b0;
    always @(posedge osc_out) begin
        metastable_reg <= osc_out;
    end
    
    // The metastable state will resolve to 1 due to positive feedback
    assign one = metastable_reg | 1'b1;  // Force to 1 if metastable_reg is X
    
    // Initial block to break simulation oscillation
    initial begin
        #1;  // Small delay to prevent simulation oscillation
    end
endmodule