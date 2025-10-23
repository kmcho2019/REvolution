module TopModule (
    input clk,
    input in,
    output out
);

    reg dff_out;
    wire xor_out;
    reg feedback_latch;
    
    // Transparent latch for feedback path (active when clk is low)
    always @(*) begin
        if (~clk) begin
            feedback_latch <= dff_out;
        end
    end
    
    // XOR of input and latched feedback
    assign xor_out = in ^ feedback_latch;
    
    // Positive edge-triggered DFF
    always @(posedge clk) begin
        dff_out <= xor_out;
    end
    
    assign out = dff_out;

endmodule