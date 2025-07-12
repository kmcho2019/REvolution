module TopModule (
    input clk,
    input in,
    output out
);

    reg dff_out;
    wire feedback_gate;
    
    // Clock-gated XOR feedback path
    assign feedback_gate = clk ? (in ^ dff_out) : 1'b0;
    
    // Positive edge-triggered DFF
    always @(posedge clk) begin
        dff_out <= feedback_gate;
    end
    
    assign out = dff_out;

endmodule