module TopModule (
    input clk,
    input in,
    output out
);

    reg dff_out = 1'bx;  // Unknown initial state (synthesis-friendly)
    wire xor_out;
    
    // Combinational XOR feedback
    assign xor_out = in ^ dff_out;
    
    // Positive edge-triggered D flip-flop
    always @(posedge clk) begin
        dff_out <= xor_out;
    end
    
    // Output assignment
    assign out = dff_out;

endmodule