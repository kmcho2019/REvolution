module TopModule (
    input clk,
    input in,
    output out
);

    reg dff_out;
    wire xor_out;
    
    // Combinational XOR logic
    assign xor_out = in ^ dff_out;
    
    // Positive edge-triggered D flip-flop
    always @(posedge clk) begin
        dff_out <= xor_out;
    end
    
    // Initialize flip-flop output
    initial begin
        dff_out = 1'b0;
    end
    
    // Connect output
    assign out = dff_out;

endmodule